//
//  CameraFeature.swift
//  FoodSizer
//
//  Created by Adam Post-Montjoie on 3/22/26.
//
import ComposableArchitecture

@Reducer
struct CameraFeature {
  @ObservableState
 struct State: Equatable {
        var count = 0
      }
    enum Action {
        case scanButtonTapped
      }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .scanButtonTapped:
        state.count -= 1
        return .none

      }
    }
  }
}
