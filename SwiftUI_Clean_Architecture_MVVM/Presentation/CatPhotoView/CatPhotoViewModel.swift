//
//  CatPhotoViewModel.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation
import Combine

@MainActor
final class CatPhotoViewModel: ObservableObject {
    @Published var imageURL: URL?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let fetchUseCase: (_ completion: @escaping (Result<CatPhoto, APIError>) -> Void) -> UseCase
    private var cancellable: Cancellable?
    
    init(fetchUseCase: @escaping (_: @escaping (Result<CatPhoto, APIError>) -> Void) -> UseCase) {
        self.fetchUseCase = fetchUseCase
    }
    
    func fetch(type: String = "square", position: String = "center") {
        cancellable?.cancel()
        errorMessage = nil
        isLoading = true
        
        let useCase = fetchUseCase{ [weak self] result in
            guard let self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let catPhoto):
                self.imageURL = catPhoto.url
            case .failure(let error):
                self.errorMessage = self.mapError(error)
            }
        }
        
        self.cancellable = useCase.start()
    }
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
        isLoading = false
    }
    
    private func mapError(_ error: APIError) -> String {
        switch error {
        case .noInternet: return "인터넷 연결이 없어요"
        case .timeout: return "요청 시간이 초과됐어요"
        case .cancelled: return "요청이 취소됐어요"
        case .unauthorized: return "인증이 필요해요"
        case .server(let statusCode, _): return "서버 오류(\(statusCode))가 발생했어요"
        case .decoding: return "응답 해석에 실패했어요"
        case .unknown: return "알 수 없는 오류가 발생했어요"
        }
    }
}
