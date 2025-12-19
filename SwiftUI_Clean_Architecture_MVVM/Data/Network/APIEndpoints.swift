//
//  APIEndpoints.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation
import Alamofire

extension Endpoint where Response == CatPhotoResponseDTO {
    static func fetchCatPhoto(type: String, position: String) -> Endpoint {
        Endpoint(
            path: "cat",
            method: .get,
            parameters: [
                "type": type,
                "position": position
            ],
            headers: ["Accept": "application/json"]
        )
    }
}

extension Endpoint where Response == CatFeedResponseDTO {
    static func fetchCatFeed(limit: Int64, skip: Int64) -> Endpoint {
        Endpoint(
            path: "api/cats",
            method: .get,
            parameters: [
                "limit": limit,
                "skip": skip
            ],
            headers: ["Accept": "application/json"]
        )
    }
}
