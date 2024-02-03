//
//  BreedListFeature.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BreedListFeature {
  @ObservableState
  struct State: Equatable {
    var breeds: [Breed] = []
    var totalPagination: Int = 0
  }

  enum Action {
    case fetchBreeds
    case fetchBreedsResponse(_ :[Breed])
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .fetchBreeds:
        return .run { send in
          let (data, _) = try await URLSession.shared
            .data(from: URL(string: "https://api.thedogapi.com/v1/breeds")!)
          let breeds = try JSONDecoder().decode([Breed].self, from: data)

          await send(.fetchBreedsResponse(breeds))
        }
      case .fetchBreedsResponse(let breeds):
        state.breeds = breeds
        state.totalPagination = breeds.count / 10
        return .none
      }
    }
  }
}

