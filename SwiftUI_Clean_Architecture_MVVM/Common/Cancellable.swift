//
//  Cancellable.swift
//  SwiftUI_Clean_Architecture_MVVM
//
//  Created by wodnd on 12/19/25.
//

import Foundation

protocol Cancellable {
    func cancel()
}

struct TaskCancellable: Cancellable {
    let task: Task<Void, Never>
    
    func cancel() {
        task.cancel()
    }
}
