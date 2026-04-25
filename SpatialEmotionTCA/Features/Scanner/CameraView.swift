//
//  CameraView.swift
//  FoodSizer
//
//  Created by Adam Post-Montjoie on 3/22/26.
//

import SwiftUI
import ComposableArchitecture

struct CameraView: View {
    @Bindable var store: StoreOf<CameraFeature>
    
    var body: some View {
        ZStack {
            // 1. The Camera (Only active when not .off)
            if store.currentMode != .off {
                ARViewContainer(
                    onSessionCreated: { session in
                        store.send(.sessionCreated(session))
                    },
                    currentMode: store.currentMode,
                    onReadyStateChanged:{ isReady in
                        store.send(.readyStateChanged(isReady:isReady))
                    }
                )
                .ignoresSafeArea()
                .transition(.opacity) // Fade out instead of snapping
            }
            
            // 2. The Premium Transition Mask
            if store.currentMode == .off {
                ZStack {
                    // iOS Frosted Glass Effect
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Configuring Sensors...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                .transition(.opacity) // Fade in
            }
            
            // 3. The Scan Button
            VStack {
                Spacer()
                
                Button {
                    store.send(.scanButtonTapped)
                } label: {
                    Text(store.currentMode == .lidar ? "Scan Object" : "Scan Face")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(store.isReadyToScan ? Color.blue : Color.gray)
                        .cornerRadius(16)
                }
                .disabled(!store.isReadyToScan)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        // 4. The magic line: Tells the ZStack to crossfade changes smoothly
        .animation(.easeInOut(duration: 0.3), value: store.currentMode)
        .onAppear {
            store.send(.onAppear)
        }
        .onDisappear{
            store.send(.onDisappear)
        }
    }
}
