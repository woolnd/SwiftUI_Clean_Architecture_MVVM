//
//  CatFeedViewModel.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation
import Combine
import UIKit

@MainActor
final class CatFeedViewModel: ObservableObject {
    @Published var items: [CatFeedItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let fetchUseCase:
    (_ limit: Int64, _ skip: Int64,
     _ completion: @escaping (Result<CatFeed, APIError>) -> Void) -> UseCase
    private var cancellable: Cancellable?
    private var imageTask: Task<Void, Never>?
    
    private let pageSize: Int64 = 30
    private var isFetchingNext = false
    private var hasMore = true
    
    init(
        fetchUseCase:
        @escaping (_ limit: Int64, _ skip: Int64,
                   _ completion: @escaping (Result<CatFeed, APIError>) -> Void) -> UseCase) {
        self.fetchUseCase = fetchUseCase
    }
    
    func refresh() {
        cancellable?.cancel()
        items = []
        errorMessage = nil
        hasMore = true
        isFetchingNext = false
        fetchNextPage()
    }
    
    func fetchNextPage() {
        guard !isFetchingNext, hasMore else { return }
        
        isFetchingNext = true
        errorMessage = nil
        isLoading = items.isEmpty
        
        let skip = Int64(items.count)
        let limit = pageSize
        
        let useCase = fetchUseCase(limit, skip) { [weak self] result in
            guard let self else { return }
            self.isFetchingNext = false
            self.isLoading = false
            
            switch result {
            case .success(let feed):
                let newItems = feed
                
                if newItems.count < Int(limit) { self.hasMore = false }
                
                let existing = Set(self.items.map(\.id))
                let filtered = newItems.filter { !existing.contains($0.id) }
                
                self.items.append(contentsOf: filtered)
                
            case .failure(let error):
                self.errorMessage = self.mapError(error)
            }
        }
        
        cancellable = useCase.start()
    }
    
    func loadMoreIfNeeded(currentItem item: CatFeedItem) {
        let threshold = 9
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        if idx >= items.count - threshold {
            fetchNextPage()
        }
    }
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
        
        imageTask?.cancel()
        imageTask = nil
        
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

