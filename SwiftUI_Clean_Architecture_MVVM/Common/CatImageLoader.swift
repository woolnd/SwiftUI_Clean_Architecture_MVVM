//
//  ImageDownsamplingManager.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation
import UIKit
import ImageIO

// 다운샘플링 + 메모리 캐시 + 중복 요청 병합 + 동시성 제한을 담당
final class CatImageLoader {
    static let shared = CatImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    private let semaphore = AsyncSemaphore(value: 4) // 동시 4개만
    
    private let inFlight = InFlightStore()
    
    /// 이미지 로드 진입점
    func load(urlString: String, targetSize: CGSize, scale: CGFloat) async throws -> UIImage {
        
        // 캐시 키 (사이즈/스케일 포함 권장)
        let cacheKey = "\(urlString)|\(Int(targetSize.width))x\(Int(targetSize.height))|\(scale)"
        
        // 메모리 캐시에 존재하면 즉시 반환
        if let cached = cache.object(forKey: urlString as NSString) {
            return cached
        }
        
        // inFlight로 동일 작업 병합
        return try await inFlight.run(key: cacheKey) {
            
            // 캐시 재확인 (대기 중 다른 Task가 채웠을 수 있음)
            if let cached = self.cache.object(forKey: cacheKey as NSString) {
                return cached
            }
            
            // 동시 작업 수 제한
            await self.semaphore.wait()
            defer { self.semaphore.signal() }
            
            if Task.isCancelled {
                throw CancellationError()
            }
            
            let url = try URL(string: urlString).unwrap()
            
            let image = try await ImageDownsamplingManager.downsample(
                remoteURL: url,
                to: targetSize,
                scale: scale
            )
            
            if Task.isCancelled {
                throw CancellationError()
            }
            
            self.cache.setObject(image, forKey: cacheKey as NSString)
            return image
        }
    }
}

// 동일 Key로 들어온 요청을 하나의 Task로 병합
actor InFlightStore {
    private var tasks: [String: Task<UIImage, Error>] = [:]
    
    // 동일한 key에 대해 이미 작업이 있으면 해당 Task의 결과를 공유
    func run(key: String, _ work: @escaping () async throws -> UIImage) async throws -> UIImage {
        // 이미 작업을 진행중이면 결과만 기다림
        if let task = tasks[key] { return try await task.value }
        
        // 작업중인게 없다면 새로운 Task 생성
        let task = Task { try await work() }
        tasks[key] = task
        
        // 작업이 끝나면 정리
        defer { tasks[key] = nil }
        
        return try await task.value
    }
}

// Optional 값을 안전하게 unwrap 하되, 실패 시 throw
private extension Optional {
    func unwrap(file: StaticString = #fileID, line: UInt = #line) throws -> Wrapped {
        guard let self else { throw URLError(.badURL) }
        return self
    }
    
}

// Swift Concurrency 환경에서 사용할 수 있는 간단한 비동기 세마포어
actor AsyncSemaphore {
    private var value: Int
    private var waiters: [CheckedContinuation<Void, Never>] = []
    
    init(value: Int) { self.value = value }
    
    func wait() async {
        if value > 0 {
            value -= 1
            return
        }
        await withCheckedContinuation { cont in
            waiters.append(cont)
        }
    }
    
    func signal() {
        if waiters.isEmpty {
            value += 1
        } else {
            waiters.removeFirst().resume()
        }
    }
}

enum ImageDownsamplingManager {
    // Data 기반 다운샘플링
    static func downsample(
        data: Data,
        to targetSize: CGSize,
        scale: CGFloat = UIScreen.main.scale,
        shouldCache: Bool = true
    ) -> UIImage? {
        
        let cfData = data as CFData
        let options: CFDictionary = [
            kCGImageSourceShouldCache: false
        ] as CFDictionary
        
        guard let source = CGImageSourceCreateWithData(cfData, options) else {
            return nil
        }
        
        let maxDimensionInPixels = max(targetSize.width, targetSize.height) * scale
        
        let downsampleOptions: CFDictionary = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: shouldCache,
            kCGImageSourceThumbnailMaxPixelSize: Int(maxDimensionInPixels)
        ] as CFDictionary
        
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    // 원격 URL 기반 다운샘플링
    static func downsample(
        remoteURL: URL,
        to targetSize: CGSize,
        scale: CGFloat = UIScreen.main.scale,
        shouldCache: Bool = true
    ) async throws -> UIImage {
        
        let (data, response) = try await URLSession.shared.data(from: remoteURL)
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }
        
        guard let image = downsample(data: data, to: targetSize, scale: scale, shouldCache: shouldCache) else {
            throw URLError(.cannotDecodeContentData)
        }
        return image
    }
}
