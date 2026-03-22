//
//  ArViewContainer.swift
//  FoodSizer
//
//  Created by Adam Post-Montjoie on 3/22/26.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) ->ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh // turns on lidar mesh
        }
        //start the camera and sensors
        arView.session.run(config)
                
        return arView
    }
    func updateUIView(_ uiView: ARView, context: Context) {}
}
