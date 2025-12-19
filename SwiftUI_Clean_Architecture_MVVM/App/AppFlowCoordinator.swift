//
//  AppFlowCoordinator.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/18/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class AppFlowCoordinator: ObservableObject {
    
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    func makeRootView() -> AnyView {
        let scene = appDIContainer.makeCatPhotoSceneDIContainer()
        let vm = scene.makeCatPhotoViewModel()
        return AnyView(CatPhotoView(viewModel: vm))
    }
}
