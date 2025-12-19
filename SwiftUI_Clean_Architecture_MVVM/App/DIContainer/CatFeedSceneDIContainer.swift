//
//  CatFeedSceneDIContainer.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation
final class CatFeedSceneDIContainer {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func makeCatFeedRepository() -> CatFeedRepository {
        DefaultCatFeedRepository(apiClient: apiClient)
    }
    
    func makeFetchCatFeedUseCase(
        requestValue: FetchCatFeedUseCase.RequestValue,
        completion: @escaping (FetchCatFeedUseCase.ResultValue) -> Void
    ) -> UseCase {
        FetchCatFeedUseCase(
            requestValue: requestValue,
            completion: completion,
            catFeedRepository: makeCatFeedRepository()
        )
    }
    
    func makeCatFeedViewModel() -> CatFeedViewModel {
        let repo = makeCatFeedRepository()
        
        return CatFeedViewModel { limit, skip, completion in
            FetchCatFeedUseCase(
                requestValue: .init(limit: limit, skip: skip),
                completion: completion,
                catFeedRepository: repo
            )
        }
    }
}
