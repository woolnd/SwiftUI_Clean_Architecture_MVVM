//
//  ImageDownsamplingManager.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation
import UIKit
import ImageIO

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
