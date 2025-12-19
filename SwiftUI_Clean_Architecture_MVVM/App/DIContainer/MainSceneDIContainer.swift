//
//  MainSceneDIContainer.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation
import SwiftUI

final class MainSceneDIContainer: MainFlowCoordinatorDependencies {
    
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    func makeMainView(actions: MainViewActions) -> MainView {
        MainView(actions: actions)
    }
    
    func makeCatPhotoView() -> CatPhotoView {
        let scene = appDIContainer.makeCatPhotoSceneDIContainer()
        let vm = scene.makeCatPhotoViewModel()
        return CatPhotoView(viewModel: vm)
    }
    
    func makeCatFeedView() -> CatFeedView {
        CatFeedView()
    }
}
