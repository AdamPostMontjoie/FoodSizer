//
//  Capture_AppApp.swift
//  Capture App
//
//  Created by Adam Post-Montjoie on 3/6/26.
//

import SwiftUI
import ComposableArchitecture

@main
struct Capture_AppApp: App {
    
    static let store = Store(initialState:CounterFeature.State()){
        CounterFeature()
        ._printChanges()
    }
    var body: some Scene {
        WindowGroup {
            CounterView(store: Capture_AppApp.store)
        }
    }
}
