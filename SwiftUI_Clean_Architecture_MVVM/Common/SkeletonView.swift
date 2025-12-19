//
//  SkeletonView.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import SwiftUI
struct SkeletonView: View {

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.gray.opacity(0.3))

            ProgressView()
        }
        .frame(width: 200, height: 200)
    }
}
