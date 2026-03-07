//
//  Capture_AppApp.swift
//  Capture App
//
//  Created by Adam Post-Montjoie on 3/6/26.
//

import SwiftUI
import ComposableArchitecture

@main
struct FoodSizer: App {
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
      }
    var body: some Scene {
        WindowGroup {
            AppView(store:FoodSizer.store)
        }
    }
}
