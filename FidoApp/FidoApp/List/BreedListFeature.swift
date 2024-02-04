//
//  BreedListFeature.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct BreedListFeature {
  @Dependency(\.fetchBreeds) var dogAPI

  @Dependency(\.swiftData) var context
  @Dependency(\.databaseService) var databaseService

  @EnvironmentObject var networkMonitor: NetworkMonitor

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
    case fetchBreeds
    case fetchOfflineBreeds
    case fetchBreedsResponse(Result<[Breed], Error>)
    case setSelection(ViewType)
    case loadMore
    case retry
    case path(StackAction<BreedDetailFeature.State, BreedDetailFeature.Action>)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
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

        let newBreeds = breeds.filter { b in
          return !state.breeds.contains(b)
        }

        state.breeds += newBreeds

        try? context.add(newBreeds)

        return .none
      case .fetchBreedsResponse(.failure(_)):
        state.dataLoadingStatus = .error
        return .none
      case .fetchOfflineBreeds:
        state.breeds = try! context.fetchAll()
        if state.breeds.isEmpty {
          return .send(.fetchBreeds)
        } else {
          return .none
        }
      case .setSelection(let viewType):
        state.selectedView = viewType
        return .none
      case .retry:
        return .send(.fetchBreeds)
      case .loadMore:
        state.currentPage += 1
        return .none
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

