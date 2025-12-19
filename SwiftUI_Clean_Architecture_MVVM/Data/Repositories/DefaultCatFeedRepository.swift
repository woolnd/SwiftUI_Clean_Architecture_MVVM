//
//  DefaultCatMetaRepository.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation

final class DefaultCatFeedRepository {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}

extension DefaultCatFeedRepository: CatFeedRepository {
    func fetchCatFeed(
        limit: Int64,
        skip: Int64,
        completion: @escaping (Result<CatFeed, APIError>) -> Void
    ) -> (any Cancellable)? {
        let task = Task {
            do {
                let dto: [CatFeedItemResponseDTO] =
                try await apiClient.request(.fetchCatFeed(limit: limit, skip: skip))
                
                let domain: CatFeed = dto.toDomain()
                completion(.success(domain))
            } catch let apiError as APIError {
                completion(.failure(apiError))
            } catch {
                completion(.failure(.unknown(error)))
            }
        }
        return TaskCancellable(task: task)
    }
}
