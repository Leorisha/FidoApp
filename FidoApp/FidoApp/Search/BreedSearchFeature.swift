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
    var dataLoadingStatus = DataLoadingStatus.notStarted
    var searchText: String = ""
    var searchResults: [Breed] = []
    var path = StackState<BreedDetailFeature.State>()
    
    var shouldShowError: Bool {
      dataLoadingStatus == .error
    }

    var isLoading: Bool {
      dataLoadingStatus == .loading
    }
  }

  enum Action {
    case updateText(_ text: String)
    case performSearch(_ text: String)
    case searchResultsResponse(Result<[Breed], Error>)
    case path(StackAction<BreedDetailFeature.State, BreedDetailFeature.Action>)
    case retry
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .updateText(let text):
        state.searchText = text
        return .none
      case .performSearch(let text):
        if state.dataLoadingStatus == .loading {
          return .none
        }

        state.dataLoadingStatus = .loading

        return .run { send in
          do {
            let breeds = try await self.dogAPI.searchBreeds(text)
            let result: Result<[Breed], Error> = .success(breeds)
            await send(.searchResultsResponse(result))
          } catch {
            let result: Result<[Breed], Error> = .failure(error)
            await send(.searchResultsResponse(result))
          }
        }
      case .searchResultsResponse(.success(let breeds)):
        state.dataLoadingStatus = .success
        state.searchResults = breeds
        return .none
      case .searchResultsResponse(.failure(let error)):
        state.dataLoadingStatus = .error
        return .none
      case .path:
        return .none
      case .retry:
        return .send(.performSearch(state.searchText))
      }
    }
    .forEach(\.path, action: \.path) {
         BreedDetailFeature()
       }
  }
}
