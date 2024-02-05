//
//  DogAPI.swift
//  FidoApp
//
//  Created by Ana Neto on 04/02/2024.
//

import Foundation
import ComposableArchitecture

struct DogAPIClient {
  var fetchBreeds: () async throws -> [Breed]
}


extension DogAPIClient: DependencyKey {
  static let liveValue = Self(
    fetchBreeds: { 
      let (data, _) = try await URLSession.shared
        .data(from: URL(string: "https://api.thedogapi.com/v1/breeds")!)
      let breeds = try JSONDecoder().decode([Breed].self, from: data)

      return breeds
    })
  
}

extension DependencyValues {
  var fetchBreeds: DogAPIClient {
    get { self[DogAPIClient.self] }
    set { self[DogAPIClient.self] = newValue }
  }
}
