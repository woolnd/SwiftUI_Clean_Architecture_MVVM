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
        CatPhotoViewModel { [weak self] completion in
            guard let self else { return EmptyUseCase() }
            
            let requestValue = FetchCatPhotoUseCase.RequestValue(
                type: "square",
                position: "center"
            )

            
            return self.makeFetchCatPhotoUseCase(
                requestValue: requestValue,
                completion: completion
            )
        }
    }
}

private struct EmptyUseCase: UseCase {
    func start() -> Cancellable? { nil }
}
