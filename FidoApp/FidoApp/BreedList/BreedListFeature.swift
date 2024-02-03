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
    var currentPage = 1
    var itemsPerPage = 10
    var selectedView: ViewType = .list
  }

  enum Action {
    case fetchBreeds(page: Int, limit: Int)
    case fetchBreedsResponse(_ :[Breed])
    case setSelection(ViewType)
    case loadMore
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .fetchBreeds(let page, let limit):
        return .run { send in
          let (data, _) = try await URLSession.shared
            .data(from: URL(string: "https://api.thedogapi.com/v1/breeds?limit=\(limit)&page=\(page)")!)
          let breeds = try JSONDecoder().decode([Breed].self, from: data)

          await send(.fetchBreedsResponse(breeds))
        }
      case .fetchBreedsResponse(let breeds):
        state.breeds += breeds
        return .none
      case .setSelection(let viewType):
        state.selectedView = viewType
        return .none
      case .loadMore:
        state.currentPage += 1
        return .send(.fetchBreeds(page: state.currentPage, limit: state.itemsPerPage))
      }
    }
  }

  enum ViewType: String, CaseIterable {
    case list = "List"
    case grid = "Grid"
  }
}

