//
//  SwiftUI_Clean_Architecture_MVVMApp.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/18/25.
//

import SwiftUI

@main
struct SwiftUI_Clean_Architecture_MVVMApp: App {
    
    @StateObject private var appFlow = AppFlowCoordinator(appDIContainer: AppDIContainer())
    
    var body: some Scene {
        WindowGroup {
            appFlow.makeRootView()
        }
    }
}
