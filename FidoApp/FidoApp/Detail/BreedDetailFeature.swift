//
//  BreedDetailFeature.swift
//  FidoApp
//
//  Created by Ana Neto on 04/02/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BreedDetailFeature {

  @ObservableState
  struct State: Equatable {
    var breed: Breed
  }

  enum Action {
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      return .none
    }
  }
}
