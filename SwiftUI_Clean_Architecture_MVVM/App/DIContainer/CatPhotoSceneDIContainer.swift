//
//  CatPhotoSceneDIContainer.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation

final class CatPhotoSceneDIContainer {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func makeCatPhotoRepository() -> CatPhotoRepository {
        DefaultCatPhotoRepository(apiClient: apiClient)
    }
    
    func makeFetchCatPhotoUseCase(
        requestValue: FetchCatPhotoUseCase.RequestValue,
        completion: @escaping (FetchCatPhotoUseCase.ResultValue) -> Void
    ) -> UseCase {
        FetchCatPhotoUseCase(
            requestValue: requestValue,
            completion: completion,
            catPhotoRepository: makeCatPhotoRepository()
        )
    }
    
    func makeCatPhotoViewModel() -> CatPhotoViewModel {
        let repo = makeCatPhotoRepository()
        
        return CatPhotoViewModel { completion in
            FetchCatPhotoUseCase(
                requestValue: .init(type: "square", position: "center"),
                completion: completion,
                catPhotoRepository: repo
            )
        }
    }
}

private struct EmptyUseCase: UseCase {
    func start() -> Cancellable? { nil }
}
