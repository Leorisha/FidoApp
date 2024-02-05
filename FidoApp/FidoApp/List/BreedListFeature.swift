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

  @ObservableState
  struct State: Equatable {
    var dataLoadingStatus = DataLoadingStatus.notStarted
    var breeds: [Breed] = []
    var displayingBreeds: [Breed] = []
    var currentPage = 1
    var itemsPerPage = 10
    var totalPages = 1
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
    case retry
    case path(StackAction<BreedDetailFeature.State, BreedDetailFeature.Action>)
    case plusPage
    case minusPage
    case filterBreeds
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
        state.totalPages = Int(ceil(Double(state.breeds.count) / Double(state.itemsPerPage)))

        try? context.add(newBreeds)

        return .send(.filterBreeds)
      case .fetchBreedsResponse(.failure(_)):
        state.dataLoadingStatus = .error
        return .none
      case .fetchOfflineBreeds:
        state.breeds = try! context.fetchAll()
        if state.breeds.isEmpty {
          return .send(.fetchBreeds)
        } else {
          state.totalPages = Int(ceil(Double(state.breeds.count) / Double(state.itemsPerPage)))

          return .send(.filterBreeds)
        }
      case .setSelection(let viewType):
        state.selectedView = viewType
        return .none
      case .retry:
        return .send(.fetchBreeds)
      case .path:
        return .none
      case .plusPage:
        if state.currentPage <= state.totalPages {
          state.currentPage += 1
        }
        return .send(.filterBreeds)
      case .minusPage:
        if state.currentPage > 0 {
          state.currentPage -= 1
        }
        return .send(.filterBreeds)
      case .filterBreeds:
        let startIndex = (state.currentPage - 1) * state.itemsPerPage
        var endIndex = startIndex + state.itemsPerPage
        endIndex = endIndex > state.breeds.count ? state.breeds.count : endIndex
        state.displayingBreeds = Array(state.breeds[startIndex..<endIndex])
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

