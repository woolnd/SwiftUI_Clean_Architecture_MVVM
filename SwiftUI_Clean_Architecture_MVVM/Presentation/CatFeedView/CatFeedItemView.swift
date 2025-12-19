//
//  CatFeedItemView.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import SwiftUI
import Combine

struct CatFeedItemView: View {
    let imageURL: String
    
    @State private var uiImage: UIImage?
    @State private var isLoading = false
    @State private var error: Bool = false
    
    var body: some View {
        ZStack {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                SkeletonView()
            } else if error {
                Color.gray.opacity(0.2)
            } else {
                Color.gray.opacity(0.2)
            }
        }
        .clipped()
        .task(id: imageURL) {
            await loadAndDownsample()
        }
    }
    
    private func loadAndDownsample() async {
        do {
            let image = try await ImageDownsamplingManager.downsample(
                remoteURL: URL(string: imageURL)!,
                to: CGSize(width: 200, height: 200)
            )

            self.uiImage = image
            self.isLoading = false
        } catch {
            self.isLoading = false
        }
    }
}

#Preview {
    CatFeedItemView(imageURL: "")
}
