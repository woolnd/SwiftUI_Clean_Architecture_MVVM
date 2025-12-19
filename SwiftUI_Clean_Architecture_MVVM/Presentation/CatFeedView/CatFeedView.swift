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
                                imageURL: "https://cataas.com/cat/\(item.id)"
                            )
                            .frame(width: side, height: side)
                            .clipped()
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
            }
        }
        .onAppear(){
            viewModel.fetch()
        }
    }
}

#Preview {
    CatFeedView(
        viewModel: CatFeedViewModel { completion in
            PreviewFetchCatFeedUseCase(completion: completion)
        }
    )
}


private final class PreviewFetchCatFeedUseCase: UseCase {
    private let completion: (Result<CatFeed, APIError>) -> Void
    
    init(completion: @escaping (Result<CatFeed, APIError>) -> Void) {
        self.completion = completion
    }
    
    func start() -> Cancellable? {
        completion(.success(
            [CatFeedItem(id: "", tags: [""], mimetype: "", createdAt: "")])
        )
        return nil
    }
}
