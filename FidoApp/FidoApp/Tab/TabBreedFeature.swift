//
//  TabBreedFeature.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TabBreedFeature {

  @ObservableState
  struct State {
    var breedList = BreedListFeature.State()
    var breedSearch = BreedSearchFeature.State()
  }

  enum Action {
    case breedListActions(BreedListFeature.Action)
    case breedSearchActions(BreedSearchFeature.Action)
  }

  var body: some ReducerOf<Self> {
    Scope(state: \.breedList, action: \.breedListActions) {
      BreedListFeature()
         }
    Scope(state: \.breedSearch, action: \.breedSearchActions) {
      BreedSearchFeature()
    }
    Reduce { state, action in
      switch action {
      case .breedListActions(_):
        return .none
      case .breedSearchActions(_):
        return .none
      }
    }
  }
}

