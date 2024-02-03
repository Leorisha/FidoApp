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
  }

  enum Action {
    case breedListActions(BreedListFeature.Action)
  }

  var body: some ReducerOf<Self> {
    Scope(state: \.breedList, action: \.breedListActions) {
      BreedListFeature()
         }
    Reduce { state, action in
      switch action {
      case .breedListActions(_):
        return .none
      }
    }
  }
}

