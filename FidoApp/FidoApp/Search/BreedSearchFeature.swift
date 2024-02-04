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
          print("https://api.thedogapi.com/v1/breeds/search?name=\(text)")
          let (data, _) = try await URLSession.shared
            .data(from: URL(string: "https://api.thedogapi.com/v1/breeds/search?q=\(text)")!)

          // Convert data to string for printing
             if let dataString = String(data: data, encoding: .utf8) {
                 print("Received Data as String:\n\(dataString)")
             } else {
                 print("Unable to convert data to string.")
             }

          let breeds = try JSONDecoder().decode([Breed].self, from: data)

          await send(.searchResultsResponse(breeds))
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
