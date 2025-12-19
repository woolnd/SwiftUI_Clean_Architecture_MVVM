//
//  Endpoint.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/18/25.
//

import Foundation
import Alamofire

struct Endpoint<Response: Decodable> {
    let path: String
    let method: HTTPMethod
    let parameters: Parameters?
    let headers: HTTPHeaders?
    
    init(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
}
