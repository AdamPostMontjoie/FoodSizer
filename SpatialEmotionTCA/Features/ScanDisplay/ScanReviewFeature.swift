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
import SceneKit


@Reducer
struct ScanReviewFeature {
  @ObservableState
 struct State: Equatable {
        var scanId: UUID
        var objURL: URL
        var faceURL: URL
        var emotion:String
        @Presents var alert: AlertState<Action.Alert>?
      }
    enum Action:Equatable {
        case deleteButtonTapped(UUID)
        case delegate(Delegate)
        case alert(PresentationAction<Alert>)
        case nodeLoadFailure(UUID)
        enum Delegate:Equatable{
            case scanRemoved(UUID)
            case scanFailedToLoad(UUID)
            case scanFailedToRemove
        }
        enum Alert:Equatable {
            case confirmDeletion(id:UUID)
        }
      }
    @Dependency(\.databaseClient) var databaseClient
    @Dependency(\.dismiss) var dismiss
    
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .nodeLoadFailure(id):
          return .run { send in
              await send(.delegate(.scanFailedToLoad(id)))
              await self.dismiss()
          }
          case let .deleteButtonTapped(id): //triggers the confirmation popup
              state.alert = .confirmDeletion(id:id)
              return .none
          case .alert(.presented(.confirmDeletion)): //the deletion is confirmed
                return .run {[id = state.scanId, obj = state.objURL, face = state.faceURL] send in
                    do {
                  try await databaseClient.deleteSession(id,obj,face)
                    print("SUCCESS: Deleted from SSD and SwiftData")
                        await send(.delegate(.scanRemoved(id)))
                     } catch {
                         
                       print("ERROR: Failed to delete - \(error)")
                         await send(.delegate(.scanFailedToRemove))
                       }
                    //bubble alert on catch or success, different messages
                    await self.dismiss()
                  }
            case .alert:
                return .none
            case .delegate:
                return .none
          }
    }.ifLet(\.$alert, action: \.alert)
  }
}

extension AlertState where Action == ScanReviewFeature.Action.Alert {
    static func confirmDeletion(id: UUID) -> Self {
        Self {
            TextState("Are you sure?")
        } actions: {
            ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                TextState("Delete")
            }
        }
    }
}
