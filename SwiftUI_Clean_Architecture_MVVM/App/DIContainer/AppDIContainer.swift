//
//  AppDIContainer.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/18/25.
//

import Foundation

final class AppDIContainer {
    lazy var apiClient: APIClient = {
        DefaultAPIClient(baseURL: URL(string: "https://cataas.com")!)
    }()
    
    func makeCatPhotoSceneDIContainer() -> CatPhotoSceneDIContainer {
        CatPhotoSceneDIContainer(apiClient: apiClient)
    }
}
