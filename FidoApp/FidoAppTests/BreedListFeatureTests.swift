//
//  BreedListFeatureTests.swift
//  FidoAppTests
//
//  Created by Ana Neto on 04/02/2024.
//

import XCTest
import SwiftData
import ComposableArchitecture
@testable import FidoApp

@MainActor
final class BreedListFeatureTests: XCTestCase {

  var data = BreedListFeatureTests.loadData()
  var displaying = Array(BreedListFeatureTests.loadData().prefix(10))

  func testFetch() async {
    let store = TestStore(initialState: BreedListFeature.State()) {
      BreedListFeature()
    } withDependencies: {
      $0.databaseService.context =  Database.noop.context
      $0.swiftData = BreedDatabase.testValue
      $0.fetchBreeds.fetchBreeds = {self.displaying}
    }

    print("TEST \(displaying)")

    await store.send(.fetchOfflineBreeds)
    await store.receive(\.fetchBreeds, timeout: 1) { state in
      state.dataLoadingStatus = .loading
    }
    await store.receive(\.fetchBreedsResponse, timeout: 1) { state in
      state.dataLoadingStatus = .success
      state.breeds = self.displaying
      state.totalPages = 1
    }

    await store.receive(\.filterBreeds, timeout: 1) { state in
      state.displayingBreeds = self.displaying
    }

    XCTAssertTrue(store.state.breeds.count == 10)
  }

  static func loadData() -> [Breed] {
    let path = Bundle.main.path(forResource: "fetch", ofType: "json")
    let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
    return try! JSONDecoder().decode([Breed].self, from: data)
  }
}
