//
//  CatFeedView.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import SwiftUI

struct CatFeedView: View {
    @StateObject var viewModel: CatFeedViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
