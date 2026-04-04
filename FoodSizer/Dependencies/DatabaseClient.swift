//
//  DatabaseClient.swift
//  FoodSizer
//
//  Created by Adam Post-Montjoie on 4/4/26.
//

import ComposableArchitecture
import Foundation
import SwiftData


struct DatabaseClient:Sendable {
    var saveSession: @Sendable (_ objURL: URL, _ faceURL: URL) throws -> Void
}

extension DatabaseClient: DependencyKey {
    static let liveValue = Self(
        saveSession: { objURL, faceURL in
            // 1. Connect to the existing SQLite database file
            let container = try ModelContainer(for: PairedScanSession.self)
            
            // 2. Create a fresh context for this specific background task
            let context = ModelContext(container)
            
            // 3. Initialize your data model
            let session = PairedScanSession(
                name: "Scan \(Date().formatted(date: .abbreviated, time: .shortened))",
                scanOneURL: objURL,
                scanTwoURL: faceURL
            )
            
            context.insert(session)
            try context.save()
        }
    )
}

extension DependencyValues {
    var databaseClient: DatabaseClient {
        get { self[DatabaseClient.self] }
        set { self[DatabaseClient.self] = newValue }
    }
}
