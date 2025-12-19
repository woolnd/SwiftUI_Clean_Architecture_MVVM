//
//  CatPhotoView.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import SwiftUI

struct CatPhotoView: View {
    @StateObject var viewModel: CatPhotoViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                if let url = viewModel.imageURL {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Text("아직 불러온 사진이 없어요.")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxHeight: 320)
            
            if viewModel.isLoading {
                ProgressView("불러오는 중...")
            }
            
            if let message = viewModel.errorMessage {
                Text(message)
                    .foregroundStyle(.red)
            }
            
            Button("고양이 사진 불러오기") {
                viewModel.fetch()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)
            .padding()
        }
        .padding()
        .onDisappear(){
            viewModel.cancel()
        }
    }
}

#Preview {
    CatPhotoView(
        viewModel: CatPhotoViewModel { completion in
            PreviewFetchCatPhotoUseCase(completion: completion)
        }
    )
}


private final class PreviewFetchCatPhotoUseCase: UseCase {
    private let completion: (Result<CatPhoto, APIError>) -> Void

    init(completion: @escaping (Result<CatPhoto, APIError>) -> Void) {
        self.completion = completion
    }

    func start() -> Cancellable? {
        completion(.success(
            CatPhoto(url: URL(string: "https://cataas.com/cat")!)
        ))
        return nil
    }
}
