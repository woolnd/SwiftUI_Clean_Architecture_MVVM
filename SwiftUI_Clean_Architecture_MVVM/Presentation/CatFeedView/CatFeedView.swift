//
//  CatFeedView.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import SwiftUI

struct CatFeedView: View {
    @StateObject var viewModel: CatFeedViewModel
    @Environment(\.displayScale) private var displayScale
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 0), count: 3)
    private let spacing: CGFloat = 2
    
    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = 2
            let horizontalPadding: CGFloat = 2
            let columnsCount = 3
            
            let totalSpacing = spacing * CGFloat(columnsCount - 1)
            let totalPadding = horizontalPadding * 2
            
            let availableWidth = geo.size.width - totalSpacing - totalPadding
            let side = floor(availableWidth / CGFloat(columnsCount))
            
            ScrollView {
                LazyVGrid(
                    columns: columns,
                    spacing: spacing) {
                        ForEach(viewModel.items, id: \.id) { item in
                            CatFeedItemView(
                              imageURL: "https://cataas.com/cat/\(item.id)",
                              targetSize: CGSize(width: side, height: side),
                              scale: displayScale
                            )
                            .frame(width: side, height: side)
                            .clipped()
                            .onAppear {
                                viewModel.loadMoreIfNeeded(currentItem: item)
                            }
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
            }
        }
        .onAppear {
            if viewModel.items.isEmpty {
                viewModel.refresh()
            }
        }
    }
}
