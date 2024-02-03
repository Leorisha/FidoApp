//
//  ContentView.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct BreedListView: View {
  let store: StoreOf<BreedListFeature>

    var body: some View {
        VStack {
        }
        .onAppear() {
          store.send(.fetchBreeds)
        }
        .padding()
    }
}

#Preview {
  BreedListView(store: Store(initialState: BreedListFeature.State()) {
      BreedListFeature()
    }
  )
}
