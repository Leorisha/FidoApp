//
//  Database.swift
//  FidoApp
//
//  Created by Ana Neto on 04/02/2024.
//

import Foundation
import SwiftData
import ComposableArchitecture

extension DependencyValues {
  var databaseService: Database {
    get { self[Database.self] }
    set { self[Database.self] = newValue }
  }
}

fileprivate let appContext: ModelContext = {
  do {

    let url = URL.applicationSupportDirectory.appending(path: "Model.sqlite")
    let config = ModelConfiguration(url: url)

    let container = try ModelContainer(for: Breed.self, configurations: config)
    return ModelContext(container)
  } catch {
    fatalError("Failed to create container.")
  }
}()

fileprivate let testContext: ModelContext = {
  do {
    let container = try ModelContainer(for: Breed.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    return ModelContext(container)
  }
  catch {
      fatalError("Failed to create container.")
    }
}()

struct Database {
  var context: () throws -> ModelContext
}

extension Database: DependencyKey {
  public static let liveValue = Self(
    context: { appContext }
  )
}

extension Database: TestDependencyKey {
  public static var previewValue = Self.noop

  public static let testValue = Self(
    context: { testContext }
  )

  static let noop = Self(
    context: { testContext }
  )
}

