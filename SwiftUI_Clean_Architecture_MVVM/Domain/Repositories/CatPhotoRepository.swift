//
//  FetchCatPhotoRepository.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation

protocol CatPhotoRepository {
    @discardableResult
    func fetchCatPhoto(
        type: String,
        position: String,
        completion: @escaping (Result<CatPhoto, APIError>) -> Void
    ) -> Cancellable?
}
