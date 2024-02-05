//
//  BreedSearchFeatureTests.swift
//  FidoAppTests
//
//  Created by Ana Neto on 05/02/2024.
//

import XCTest
import SwiftData
import ComposableArchitecture
@testable import FidoApp

@MainActor
final class BreedSearchFeatureTests: XCTestCase {

  var data = BreedSearchFeatureTests.loadData()
  var displaying = Array(BreedSearchFeatureTests.loadData().prefix(10))
  struct BreedError: Equatable, Error {}

  func testFetch() async {
    let store = TestStore(initialState: BreedSearchFeature.State()) {
      BreedSearchFeature()
    } withDependencies: {
      $0.databaseService.context =  Database.noop.context
      $0.swiftData = BreedDatabase.testValue
      $0.fetchBreeds.fetchBreeds = {self.displaying}
    }

    await store.send(.fetchOfflineBreeds)
    await store.receive(\.fetchBreeds, timeout: 1) { state in
      state.dataLoadingStatus = .loading
    }
    await store.receive(\.fetchBreedsResponse.success, timeout: 1) { state in
      state.dataLoadingStatus = .success
      state.allBreeds = self.displaying
    }

    XCTAssertTrue(store.state.allBreeds.count == 10)
  }

  func testFetchFail() async {
    let store = TestStore(initialState: BreedSearchFeature.State()) {
      BreedSearchFeature()
    } withDependencies: {
      $0.databaseService.context =  Database.noop.context
      $0.swiftData = BreedDatabase.testValue
      $0.fetchBreeds.fetchBreeds = { throw BreedError()}
    }

    await store.send(.fetchOfflineBreeds)
    await store.receive(\.fetchBreeds, timeout: 1) { state in
      state.dataLoadingStatus = .loading
    }
    await store.receive(\.fetchBreedsResponse.failure, timeout: 1) { state in
      state.dataLoadingStatus = .error
      state.allBreeds = []
    }
  }

  static func loadData() -> [Breed] {
    let path = Bundle.main.path(forResource: "fetch", ofType: "json")
    let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
    return try! JSONDecoder().decode([Breed].self, from: data)
  }
}
