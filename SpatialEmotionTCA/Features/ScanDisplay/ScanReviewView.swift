import SwiftUI
import ComposableArchitecture
import SceneKit
import Dependencies

struct ScanReviewView: View {
    @Bindable var store: StoreOf<ScanReviewFeature>
    
    // local node state
    @State private var faceNode: SCNNode? = nil
    @State private var objNode: SCNNode? = nil
    
    @Dependency(\.sceneExtractionClient) var sceneExtractionClient
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Emotion: \(store.emotion)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                //Because we don't really care about testing node load times in this app, all we need to do is let the view handle it. As of now, this doesn't dictate how the app behaves, only how it looks, so it remains in view as no business logic
                //Since we never need to call updateuiview in the uiview representable, this remains until we leave the screen
                if let node = faceNode {
                    FaceView(faceNode: node, faceColor: EmotionClassification().EmotionalColor(store.emotion))
                        .frame(height: 300)
                        .cornerRadius(12)
                        .padding(.horizontal)
                } else {
                    LoadingPlaceholder(text: "Loading Face Scan...")
                        .task {
                            do {
                                //extract the node
                                faceNode = try await sceneExtractionClient.parseNode(store.faceURL)
                            } catch {
                                store.send(.nodeLoadFailure(store.scanId))
                            }
                        }
                }
                
                VStack(spacing: 30) {
                    Text("Where it happened")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    if store.emotion == "IShowSpeed" {
                        Image("speed")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(12)
                    } else {
                        if let node = objNode {
                            ObjectView(objectNode: node)
                                .frame(height: 300)
                                .cornerRadius(12)
                        } else {
                            // same local pattern
                            LoadingPlaceholder(text: "Loading Object Scan...")
                                .task {
                                    do {
                                        objNode = try await sceneExtractionClient.parseNode(store.objURL)
                                    } catch {
                                        store.send(.nodeLoadFailure(store.scanId))
                                    }
                                }
                        }
                    }
                }
                .padding()
                
                Button("Delete Scan") { store.send(.deleteButtonTapped(store.scanId)) }
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(12)
            }
            .padding(.bottom, 40)
        }
        .navigationTitle("Review Scan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

// Lil component
struct LoadingPlaceholder: View {
    let text: String
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text(text)
                .foregroundColor(.gray)
                .padding(.top, 8)
        }
        .frame(height: 300)
    }
}
