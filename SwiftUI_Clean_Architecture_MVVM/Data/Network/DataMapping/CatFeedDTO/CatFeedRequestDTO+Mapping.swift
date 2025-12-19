//
//  CatMetaRequestDTO+Mapping.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation

struct CatFeedRequestDTO: Encodable {
    let limit: Int64
    let skip: Int64
}
