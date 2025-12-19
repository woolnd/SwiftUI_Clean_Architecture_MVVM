//
//  CatMetaRepository.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation

protocol CatFeedRepository {
    @discardableResult
    func fetchCatFeed(
        limit: Int64,
        skip: Int64,
        completion: @escaping (Result<CatFeed, APIError>) -> Void
    ) -> Cancellable?
}
