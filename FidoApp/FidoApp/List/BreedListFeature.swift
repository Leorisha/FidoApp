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
    var dataLoadingStatus = DataLoadingStatus.notStarted
    var breeds: [Breed] = []
    var currentPage = 1
    var itemsPerPage = 10
    var selectedView: ViewType = .list

    var path = StackState<BreedDetailFeature.State>()

    var shouldShowError: Bool {
      dataLoadingStatus == .error
    }

    var isLoading: Bool {
      dataLoadingStatus == .loading
    }
  }

  enum Action {
    case fetchBreeds(page: Int, limit: Int)
    case fetchBreedsResponse(Result<[Breed], Error>)
    case setSelection(ViewType)
    case loadMore
    case retry
    case path(StackAction<BreedDetailFeature.State, BreedDetailFeature.Action>)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .fetchBreeds(let page, let limit):
        if state.dataLoadingStatus == .loading {
          return .none
        }

        state.dataLoadingStatus = .loading


        return .run { send in
          do {
            let breeds = try await self.dogAPI.fetchBreeds(limit, page)
            let result: Result<[Breed], Error> = .success(breeds)
            await send(.fetchBreedsResponse(result))
          } catch {
            let result: Result<[Breed], Error> = .failure(error)
            await send(.fetchBreedsResponse(result))
          }
        }
      case .fetchBreedsResponse(.success(let breeds)):
        state.dataLoadingStatus = .success
        state.breeds += breeds
        return .none
      case .fetchBreedsResponse(.failure(let error)):
        state.dataLoadingStatus = .error
        return .none
      case .setSelection(let viewType):
        state.selectedView = viewType
        return .none
      case .retry:
        return .send(.fetchBreeds(page: state.currentPage, limit: state.itemsPerPage))
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

