//
//  MainView.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import SwiftUI

struct MainView: View {
    let actions: MainViewActions

    var body: some View {
        VStack(spacing: 30) {
            Button("사용자 설정 이미지 보기") { actions.showCustom() }
            Button("이미지 피드 보기") { actions.showFeed() }
        }
        .padding()
        .navigationTitle("Main")
    }
}
