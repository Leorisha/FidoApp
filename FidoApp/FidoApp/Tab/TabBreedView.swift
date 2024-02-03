//
//  TabBreedView.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct TabBreedView: View {

  var store: StoreOf<TabBreedFeature>

    var body: some View {
      VStack {
        TabView {
          BreedListView(store: store.scope(state: \.breedList, action: \.breedListActions))
            .tabItem { Text("Breeds") }
          SearchBreedView()
            .tabItem { Text("Search") }
        }
      }
    }
}

#Preview {
  TabBreedView(store: Store(initialState: TabBreedFeature.State()){
    TabBreedFeature()
  })
}
