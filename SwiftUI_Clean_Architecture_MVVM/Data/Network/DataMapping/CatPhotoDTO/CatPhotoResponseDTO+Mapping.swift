//
//  CatPhotoResponseDTO.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation
struct CatPhotoResponseDTO: Decodable {
    let url: String
}

extension CatPhotoResponseDTO {
    func toDomain() -> CatPhoto? {
        guard let url = URL(string: url) else { return nil }
        return CatPhoto(url: url)
    }
}
