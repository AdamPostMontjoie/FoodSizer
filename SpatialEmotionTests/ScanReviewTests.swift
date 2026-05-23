//
//  ScanReviewTests.swift
//  SpatialEmotion
//
//  Created by Adam Post on 5/17/26.
//

import ComposableArchitecture
import XCTest
@testable import SpatialEmotion
import ARKit


@MainActor
final class ScanReviewTests: XCTestCase {
    func testDeletion() async {
        let mockUUID1 = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        let mockMeshURL = URL(string: "file://mock-mesh-path.usdz")!
        let mockFaceURL = URL(string: "file://mock-face-path.usdz")!
        let store = TestStore(initialState: ScanReviewFeature.State(scanId: mockUUID1, objURL: mockMeshURL, faceURL: mockFaceURL, emotion: "IShowSpeed"
        )) {
            ScanReviewFeature()
        } withDependencies: {
            $0.databaseClient.deleteSession = { _,_,_ in
            }
        }
        
        await store.send(.deleteButtonTapped(mockUUID1)){
            $0.alert = .confirmDeletion(id: mockUUID1)
        }
        
        await store.send(.alert(.presented(.confirmDeletion(id: mockUUID1)))){
            $0.alert = nil
        }
        await store.receive(.delegate(.scanRemoved(mockUUID1)))
    }
    
    func testFailedDeletion() async {
        let mockUUID1 = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        let mockMeshURL = URL(string: "file://mock-mesh-path.usdz")!
        let mockFaceURL = URL(string: "file://mock-face-path.usdz")!
        struct MockError: Error {}
        let store = TestStore(initialState: ScanReviewFeature.State(scanId: mockUUID1, objURL: mockMeshURL, faceURL: mockFaceURL, emotion: "IShowSpeed"
        )) {
            ScanReviewFeature()
        } withDependencies: {
            $0.databaseClient.deleteSession = { _,_,_ in
                throw MockError()
            }
        }
        
        await store.send(.deleteButtonTapped(mockUUID1)){
            $0.alert = .confirmDeletion(id: mockUUID1)
        }
        
        await store.send(.alert(.presented(.confirmDeletion(id: mockUUID1)))){
            $0.alert = nil
        }
        await store.receive(.delegate(.scanFailedToRemove))
    }
    
    func testFailedLoad() async {
        let mockUUID1 = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        let mockMeshURL = URL(string: "file://mock-mesh-path.usdz")!
        let mockFaceURL = URL(string: "file://mock-face-path.usdz")!
        let store = TestStore(initialState: ScanReviewFeature.State(scanId: mockUUID1, objURL: mockMeshURL, faceURL: mockFaceURL, emotion: "IShowSpeed"
        )) {
            ScanReviewFeature()
        }
        
        await store.send(.nodeLoadFailure(mockUUID1))
        
        await store.receive(.delegate(.scanFailedToLoad(mockUUID1)))
        
        XCTAssertTrue(store.isDismissed)
        
    }
    
    
}
