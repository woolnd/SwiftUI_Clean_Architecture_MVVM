//
//  CatMetaResponse+Mapping.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation
struct CatFeedResponseDTO: Decodable {
    let id: String
    let tags: [String]
    let mimetype: String
    let createdAt: Date?
}


extension CatFeedResponseDTO {
    func toDomain() -> CatFeed? {
        return CatFeed(
            id: id,
            tags: tags,
            mimetype: mimetype,
            createdAt: createdAt
        )
    }
}
