//
//  DogAPI.swift
//  FidoApp
//
//  Created by Ana Neto on 04/02/2024.
//

import Foundation
import ComposableArchitecture

struct DogAPIClient {
  var fetchBreeds: (Int, Int) async throws -> [Breed]
  var searchBreeds: (String) async throws -> [Breed]
}


extension DogAPIClient: DependencyKey {
  static let liveValue = Self(
    fetchBreeds: { limit, page in
      let (data, _) = try await URLSession.shared
        .data(from: URL(string: "https://api.thedogapi.com/v1/breeds?limit=\(limit)&page=\(page)")!)
      let breeds = try JSONDecoder().decode([Breed].self, from: data)

      return breeds
    }) { text in
      let (data, _) = try await URLSession.shared
        .data(from: URL(string: "https://api.thedogapi.com/v1/breeds/search?q=\(text)")!)
      let breeds = try JSONDecoder().decode([Breed].self, from: data)
      return breeds
    }
}

extension DependencyValues {
  var fetchBreeds: DogAPIClient {
    get { self[DogAPIClient.self] }
    set { self[DogAPIClient.self] = newValue }
  }

  var searchBreeds: DogAPIClient {
    get { self[DogAPIClient.self] }
    set { self[DogAPIClient.self] = newValue }
  }
}
