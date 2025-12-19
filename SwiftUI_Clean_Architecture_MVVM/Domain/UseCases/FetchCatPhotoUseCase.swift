//
//  FetchCatPhotoUseCase.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation

final class FetchCatPhotoUseCase: UseCase {
    
    struct RequestValue {
        let type: String
        let position: String
    }
    
    typealias ResultValue = Result<CatPhoto, APIError>
    
    private let requestValue: RequestValue
    private let completion: (ResultValue) -> Void
    private let catPhotoRepository: CatPhotoRepository
    
    init(requestValue: RequestValue,
         completion: @escaping (ResultValue) -> Void,
         catPhotoRepository: CatPhotoRepository) {
        self.requestValue = requestValue
        self.completion = completion
        self.catPhotoRepository = catPhotoRepository
    }
    
    @discardableResult
    func start() -> (any Cancellable)? {
        return catPhotoRepository.fetchCatPhoto(
            type: requestValue.type,
            position: requestValue.position,
            completion: completion)
    }
}
