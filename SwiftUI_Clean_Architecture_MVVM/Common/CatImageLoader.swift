//
//  ImageDownsamplingManager.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation
import UIKit
import ImageIO

final class CatImageLoader {
    static let shared = CatImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    private let semaphore = AsyncSemaphore(value: 4) // 동시 4개만

    func load(urlString: String, targetSize: CGSize, scale: CGFloat) async throws -> UIImage {
        if let cached = cache.object(forKey: urlString as NSString) {
            return cached
        }

        await semaphore.wait()
        defer { semaphore.signal() }

        // 캐시 재확인(대기 중 다른 task가 채웠을 수도)
        if let cached = cache.object(forKey: urlString as NSString) {
            return cached
        }

        let url = URL(string: urlString)!
        let image = try await ImageDownsamplingManager.downsample(
            remoteURL: url,
            to: targetSize,
            scale: scale
        )
        cache.setObject(image, forKey: urlString as NSString)
        return image
    }
}

// 간단 AsyncSemaphore
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
