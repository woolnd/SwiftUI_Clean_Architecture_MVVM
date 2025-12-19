//
//  CatMeta.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation

struct CatFeed: Identifiable, Hashable {
    let id: String
    let tags: [String]
    let mimetype: String
    let createdAt: Date?
}
