//
//  DefaultCatPhotoRepository.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation

final class DefaultCatPhotoRepository {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}

extension DefaultCatPhotoRepository: CatPhotoRepository {
    func fetchCatPhoto(
        type: String,
        position: String,
        completion: @escaping (Result<CatPhoto, APIError>) -> Void
    ) -> (any Cancellable)? {
        
        let task = Task {
            do {
                let dto = try await apiClient.request(.fetchCatPhoto(type: type, position: position))
                guard let domain = dto.toDomain() else {
                    completion(.failure(.server(statusCode: 200, message: "Invalid URL: \(dto.url)")))
                    return
                }
                
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
