//
//  ArViewContainer.swift
//  FoodSizer
//
//  Created by Adam Post-Montjoie on 3/22/26.
//

import SwiftUI
import ARKit
import RealityKit


@MainActor
struct ARViewContainer: UIViewRepresentable {
    
    //callback function that sends it from view
    var onSessionCreated:(UncheckedSession) -> Void
    var currentMode:CameraMode
    
    class Coordinator {
        var lastMode:CameraMode? = nil
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) ->ARView {
        let arView = ARView(frame: .zero)
        
        let wrappedSession = UncheckedSession(rawValue: arView.session)
        //dispatch session
        DispatchQueue.main.async {
            self.onSessionCreated(wrappedSession)
        }
        return arView
    }
    func updateUIView(_ uiView: ARView, context: Context) {
        guard self.currentMode != context.coordinator.lastMode else { return }
        context.coordinator.lastMode = self.currentMode
        switch self.currentMode{
            case .lidar:
            let config = ARWorldTrackingConfiguration()
                        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) {
                            config.sceneReconstruction = .meshWithClassification
                            uiView.debugOptions = [.showSceneUnderstanding]
                        }
                        // IMPORTANT: .resetTracking and .removeExistingAnchors flush the old face tracking data from RAM
                        uiView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        case .face:
            let config = ARFaceTrackingConfiguration()
            uiView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        case .off:
            uiView.session.pause()
        }
    }
}

//we do not mutate ARSession ever, so it is ok to send
struct UncheckedSession: @unchecked Sendable {
    let rawValue: ARSession
}
