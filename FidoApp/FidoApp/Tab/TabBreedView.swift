//
//  TabBreedView.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct BreedTabView: View {

  var store: StoreOf<TabBreedFeature>

    var body: some View {
      VStack {
        TabView {
          BreedListView(store: store.scope(state: \.breedList, action: \.breedListActions))
            .tabItem { Text("Breeds")}
          BreedSearchView(store: store.scope(state: \.breedSearch, action: \.breedSearchActions))
            .tabItem { Text("Search") }
        }
      }
    }
}

#Preview {
  BreedTabView(store: Store(initialState: TabBreedFeature.State()){
    TabBreedFeature()
  })
}
