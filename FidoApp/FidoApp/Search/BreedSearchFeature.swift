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

  @Dependency(\.fetchBreeds) var dogAPI
  @Dependency(\.swiftData) var context
  @Dependency(\.databaseService) var databaseService
  
  @ObservableState
  struct State: Equatable {
    var dataLoadingStatus = DataLoadingStatus.notStarted
    var searchText: String = ""
    var allBreeds: [Breed] = []
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
    case path(StackAction<BreedDetailFeature.State, BreedDetailFeature.Action>)
    case retry
    case fetchOfflineBreeds
    case fetchBreeds
    case fetchBreedsResponse(Result<[Breed], Error>)
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

        state.searchResults = state.allBreeds.filter{ breed in
          return breed.name.lowercased().contains(text.lowercased())
        }

        print(state.searchResults)
        state.dataLoadingStatus = .success

        return .none
      case .fetchBreeds:

        if state.dataLoadingStatus == .loading {
          return .none
        }

        state.dataLoadingStatus = .loading

        return .run { send in
          do {
            let breeds = try await self.dogAPI.fetchBreeds()
            let result: Result<[Breed], Error> = .success(breeds)
            await send(.fetchBreedsResponse(result))
          } catch {
            let result: Result<[Breed], Error> = .failure(error)
            await send(.fetchBreedsResponse(result))
          }
        }
      case .fetchBreedsResponse(.success(let breeds)):
        state.dataLoadingStatus = .success

        state.allBreeds += breeds

        try? context.add(breeds)

        return .none
      case .fetchBreedsResponse(.failure(_)):
        state.dataLoadingStatus = .error
        return .none
      case .fetchOfflineBreeds:
        state.allBreeds = try! context.fetchAll()
        if state.allBreeds.isEmpty {
          return .send(.fetchBreeds)
        } else {
          return .none
        }
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
