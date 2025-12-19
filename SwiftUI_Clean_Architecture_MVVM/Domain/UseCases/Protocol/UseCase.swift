//
//  UseCase.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation

protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
