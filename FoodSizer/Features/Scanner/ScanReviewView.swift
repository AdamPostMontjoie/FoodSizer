//
//  ScanReviewView.swift
//  FoodSizer
//
//  Created by Adam Post-Montjoie on 3/22/26.
//

import SwiftUI
import ComposableArchitecture

struct ScanReviewView: View {
    let store: StoreOf<ScanReviewFeature>
    
    var body: some View {
        VStack(spacing: 30) {
            Text("3D Scan Captured!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Placeholder for 3D Model Rendering")
                .foregroundColor(.gray)
            
            // Your Counter Logic
            HStack(spacing: 30) {
                Button("-") { store.send(.decrementButtonTapped) }
                    .font(.largeTitle)
                    .frame(width: 60, height: 60)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(12)
                
                Text("\(store.count)")
                    .font(.system(size: 50, weight: .bold))
                
                Button("+") { store.send(.incrementButtonTapped) }
                    .font(.largeTitle)
                    .frame(width: 60, height: 60)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(12)
            }
            
            if let fact = store.numberFact {
                Text(fact)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Review Scan")
        .navigationBarTitleDisplayMode(.inline)
    }
}
