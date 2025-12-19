//
//  FetchCatPhotosUseCase.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation

final class FetchCatFeedUseCase: UseCase {
    
    struct RequestValue {
        let limit: Int64
        let skip: Int64
    }
    
    typealias ResultValue = Result<CatFeed, APIError>
    
    private let requestValue: RequestValue
    private let completion: (ResultValue) -> Void
    private let catFeedRepository: CatFeedRepository
    
    init(requestValue: RequestValue,
         completion: @escaping (ResultValue) -> Void,
         catFeedRepository: CatFeedRepository) {
        self.requestValue = requestValue
        self.completion = completion
        self.catFeedRepository = catFeedRepository
    }
    
    @discardableResult
    func start() -> Cancellable? {
        return catFeedRepository.fetchCatFeed(
            limit: requestValue.limit,
            skip: requestValue.skip,
            completion: completion)
    }
}
