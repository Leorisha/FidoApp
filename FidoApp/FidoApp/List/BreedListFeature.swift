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

    var isOnline: Bool = false
  }

  enum Action {
    case fetchBreeds(page: Int, limit: Int)
    case fetchOfflineBreeds
    case fetchBreedsResponse(Result<[Breed], Error>)
    case setSelection(ViewType)
    case loadMore
    case retry
    case updateOnline(value: Bool)
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
        print(state.breeds)
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
      case .updateOnline(let newValue):
        state.isOnline = networkMonitor.isConnected || newValue
        if state.isOnline {
          return .none
        } else {
          return .send(.fetchOfflineBreeds)
        }
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

