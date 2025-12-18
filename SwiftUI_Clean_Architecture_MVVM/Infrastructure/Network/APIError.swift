//
//  APIError.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/18/25.
//

import Foundation
enum APIError: Error {
    case noInternet
    case timeout
    case cancelled
    case server(statusCode: Int, message: String?)
    case unauthorized
    case decoding(Error)
    case unknown(Error)
}
