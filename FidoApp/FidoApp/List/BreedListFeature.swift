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
  @Dependency(\.fetchBreeds) var dogAPI

  @ObservableState
  struct State: Equatable {
    var breeds: [Breed] = []
    var currentPage = 1
    var itemsPerPage = 10
    var selectedView: ViewType = .list

    var path = StackState<BreedDetailFeature.State>()
  }

  enum Action {
    case fetchBreeds(page: Int, limit: Int)
    case fetchBreedsResponse(_ :[Breed])
    case setSelection(ViewType)
    case loadMore
    case path(StackAction<BreedDetailFeature.State, BreedDetailFeature.Action>)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .fetchBreeds(let page, let limit):
        return .run { send in
          try await send(.fetchBreedsResponse(self.dogAPI.fetchBreeds(limit, page)))
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
      case .path:
             return .none
      }
    }
    .forEach(\.path, action: \.path) {
         BreedDetailFeature()
       }
  }

  enum ViewType: String, CaseIterable {
    case list = "List"
    case grid = "Grid"
  }
}

