//
//  SceneParsingClient.swift
//  FoodSizer
//
//  Created by Adam Post-Montjoie on 4/18/26.
//

import ComposableArchitecture
import SceneKit

struct SceneParsingClient:Sendable {
    var parseFace: @Sendable (_ url: URL) async throws -> SCNNode
    var parseObject: @Sendable (_ url: URL) async throws -> SCNNode
}

extension SceneParsingClient:DependencyKey {
    static let liveValue = Self(
        //placeholders
        parseFace: { faceUrl in
            return SCNNode()
        },
        parseObject: { objUrl in
            return SCNNode()
        }
    )
}

extension DependencyValues {
    var sceneParsingClient: SceneParsingClient {
        get { self[SceneParsingClient.self] }
        set { self[SceneParsingClient.self] = newValue }
    }
}
