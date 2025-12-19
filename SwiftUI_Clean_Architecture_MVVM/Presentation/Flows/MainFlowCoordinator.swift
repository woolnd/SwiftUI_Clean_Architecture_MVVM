//
//  CatFlowCoordinatro.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation
import Combine
import SwiftUI

protocol MainFlowCoordinatorDependencies {
    func makeMainView(actions: MainViewActions) -> MainView
    func makeCatPhotoView() -> CatPhotoView
    func makeCatFeedView() -> CatFeedView
}

@MainActor
final class MainFlowCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let dependencies: MainFlowCoordinatorDependencies

    init(dependencies: MainFlowCoordinatorDependencies) {
        self.dependencies = dependencies
    }

    func makeMainView() -> MainView {
        let actions = MainViewActions(
            showCustom: { [weak self] in self?.showCustom() },
            showFeed: { [weak self] in self?.showFeed() }
        )
        return dependencies.makeMainView(actions: actions)
    }

    @ViewBuilder
    func makeDestination(_ route: MainRoute) -> some View {
        switch route {
        case .custom:
            dependencies.makeCatPhotoView()
        case .feed:
            dependencies.makeCatFeedView()
        }
    }

    private func showCustom() { path.append(MainRoute.custom) }
    private func showFeed() { path.append(MainRoute.feed) }
}
