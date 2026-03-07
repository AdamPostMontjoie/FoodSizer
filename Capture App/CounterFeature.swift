//
//  CounterFeature.swift
//  Capture App
//
//  Created by Adam Post-Montjoie on 3/6/26.
//

import ComposableArchitecture
import SwiftUI

enum CancelID: Hashable, Sendable {
    case timer
}

@Reducer
nonisolated struct CounterFeature{
    @ObservableState
    struct State:Equatable{
        var count = 0
        var fact:String? = nil
        var isLoading = false
        var isTimerRunning = false
    }
    
    enum Action{
        case incrementButtonTapped
        case decrementButtonTapped
        case resetButtonTapped
        case factButtonTapped
        case factReponse(String)
        case toggleButtonTimerTapped
        case timerTapped
    }
    //enum CancelID:Sendable { case timer }
      
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self>{
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .resetButtonTapped:
                state.isTimerRunning = false
                state.count = 0
                state.fact = nil
                return .none
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                //[count = state.count] is a snapshot which stops the state from updating mid async operation if the user clicks it 10 times, keeping og value
                return .run {[count = state.count] send in
                    let (data, _) = try await URLSession.shared
                        .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    await send(.factReponse(fact))
                } catch: { error, send in
                    // If it fails, we MUST tell the state to stop loading
                    await send(.factReponse("Could not load fact. \(error)"))
                }
            case let .factReponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
            case .timerTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .toggleButtonTimerTapped:
                            state.isTimerRunning = !state.isTimerRunning
                            if state.isTimerRunning {
                                return .run { send in
                                    while true {
                                        for await _ in self.clock.timer(interval: .seconds(1)) {
                                            await send(.timerTick)
                                        }
                                    }
                                }
                                .cancellable(id: CancelID.timer)
                            } else {
                                return .cancel(id: CancelID.timer)
                            }
                        } // This closes the switch
                    } // This closes the Reduce { ... }
                } // This closes the var body
} // This closes the struct


struct CounterView: View {
    let store: StoreOf<CounterFeature>
    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            HStack {
                Button("-") {
                    store.send(.decrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
            Button("Reset Everything"){
                store.send(.resetButtonTapped)
            }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            Button(store.isTimerRunning ? "Stop timer" : "Start timer") {
                    store.send(.toggleButtonTimerTapped)
                  }
                  .font(.largeTitle)
                  .padding()
                  .background(Color.black.opacity(0.1))
                  .cornerRadius(10)
            Button("Fact") {
                   store.send(.factButtonTapped)
                 }
                 .font(.largeTitle)
                 .padding()
                 .background(Color.black.opacity(0.1))
                 .cornerRadius(10)
            if store.isLoading {
                    ProgressView()
            } else if let fact = store.fact {
                Text(fact)
                  .font(.largeTitle)
                  .multilineTextAlignment(.center)
                  .padding()
            }
        }
    }
}
#Preview {
  CounterView(
    store: Store(initialState: CounterFeature.State()) {
      CounterFeature()
    }
  )
}
    

