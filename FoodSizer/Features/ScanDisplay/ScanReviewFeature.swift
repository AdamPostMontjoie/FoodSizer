//
//  ScanReviewFeature.swift
//  FoodSizer
//
//  Created by Adam Post-Montjoie on 3/22/26.
//

//
//  CameraFeature.swift
//  FoodSizer
//
//  Created by Adam Post-Montjoie on 3/22/26.
//
import ComposableArchitecture
import Foundation

@Reducer
struct ScanReviewFeature {
  @ObservableState
 struct State: Equatable {
           var scanId: UUID
           var objUrl: URL
           var faceUrl: URL
      }
    enum Action {
        case deleteButtonTapped
        case onAppear
        case onDisappear
        case delegate(Delegate)
        enum Delegate{
            case scanRemoved(UUID)
        }
      }
    @Dependency(\.databaseClient) var databaseClient
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
          case .onAppear:
              return .none //.merge, and have an is loaded check to keep this good. attach cancelable id to merge
          case .onDisappear:
              return .none //kill any cancelable background tasks if they're running
          case .deleteButtonTapped:
            return .run {[id = state.scanId, obj = state.objUrl, face = state.faceUrl] send in
                do {
                // try await deleteScanClient.delete(id: id, objUrl: obj, faceUrl: face)
                try await databaseClient.deleteSession(id,obj,face)
                print("SUCCESS: Deleted from SSD and SwiftData")
                    await send(.delegate(.scanRemoved(id)))
                 } catch {
                   print("ERROR: Failed to delete - \(error)")
                   }
              }
          case .delegate:
              return .none
          }
    }
  }
}
