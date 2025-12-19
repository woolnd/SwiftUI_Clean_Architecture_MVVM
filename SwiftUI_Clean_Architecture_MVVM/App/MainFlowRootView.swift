//
//  MainFlowRootView.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import SwiftUI

struct MainFlowRootView: View {
    @StateObject var coordinator: MainFlowCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.makeMainView()
                .navigationDestination(for: MainRoute.self) { route in
                    coordinator.makeDestination(route)
                }
        }
    }
}
