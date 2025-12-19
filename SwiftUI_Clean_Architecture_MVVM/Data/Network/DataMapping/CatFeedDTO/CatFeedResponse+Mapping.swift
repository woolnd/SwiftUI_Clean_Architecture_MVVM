//
//  CatMetaResponse+Mapping.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation
struct CatFeedItemResponseDTO: Decodable {
    let id: String
    let tags: [String]
    let mimetype: String
    let createdAt: String
}


extension CatFeedItemResponseDTO {
    func toDomain() -> CatFeedItem {
        return CatFeedItem(
            id: id,
            tags: tags,
            mimetype: mimetype,
            createdAt: createdAt
        )
    }
}

typealias CatFeed = [CatFeedItem]

extension Array where Element == CatFeedItemResponseDTO {
    func toDomain() -> CatFeed {
        map { $0.toDomain() }
    }
}
