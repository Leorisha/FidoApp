//
//  BreedSearchFeature.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BreedSearchFeature {

  @Dependency(\.searchBreeds) var dogAPI

  @ObservableState
  struct State: Equatable {
    var searchText: String = ""
    var searchResults: [Breed] = []
    var path = StackState<BreedDetailFeature.State>()

  }

  enum Action {
    case updateText(_ text: String)
    case performSearch(_ text: String)
    case searchResultsResponse(_ :[Breed])
    case path(StackAction<BreedDetailFeature.State, BreedDetailFeature.Action>)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .updateText(let text):
        state.searchText = text
        return .none
      case .performSearch(let text):
        return .run { send in
          try await send(.searchResultsResponse(self.dogAPI.searchBreeds(text)))
        }
      case .searchResultsResponse(let breeds):
        state.searchResults = breeds
        return .none
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
         BreedDetailFeature()
       }
  }
}
