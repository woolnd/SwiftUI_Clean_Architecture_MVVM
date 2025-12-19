//
//  APIClient.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/18/25.
//

import Foundation
import Alamofire

protocol APIClient {
    func request<T: Decodable>(_ endpoint: Endpoint<T>) async throws -> T
}

final class DefaultAPIClient: APIClient {
    
    private let baseURL: URL
    private let session: Session
    private let commonHeaders: HTTPHeaders
    
    init(
        baseURL: URL,
        session: Session = .default,
        commonHeaders: HTTPHeaders = [:]
    ) {
        self.baseURL = baseURL
        self.session = session
        self.commonHeaders = commonHeaders
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint<T>) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint.path)
        
        var mergedHeaders = commonHeaders
        endpoint.headers?.forEach { mergedHeaders.add($0) }
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: endpoint.method,
                parameters: endpoint.parameters,
                encoding: endpoint.method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: mergedHeaders
            )
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                    
                case .failure(let error):
                    let apiError = self.handleError(error, response: response)
                    continuation.resume(throwing: apiError)
                }
            }
        }
    }
    
    private func handleError<T>(_ error: AFError, response: AFDataResponse<T>) -> APIError {
        // HTTP 상태 코드 체크
        if let statusCode = response.response?.statusCode {
            if statusCode == 401 {
                return .unauthorized
            }
            let message = response.data.flatMap { String(data: $0, encoding: .utf8) }
            return .server(statusCode: statusCode, message: message)
        }
        
        // URLError 체크
        if let urlError = error.underlyingError as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .noInternet
            case .timedOut:
                return .timeout
            case .cancelled:
                return .cancelled
            default:
                return .unknown(urlError)
            }
        }
        
        // 디코딩 에러 체크
        if case .responseSerializationFailed(let reason) = error,
           case .decodingFailed(let decodingError) = reason {
            return .decoding(decodingError)
        }
        
        return .unknown(error)
    }
}
