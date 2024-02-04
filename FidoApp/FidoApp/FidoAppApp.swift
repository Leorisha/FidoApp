//
//  FidoAppApp.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct FidoAppApp: App {

  @Dependency(\.databaseService) var databaseService
  var modelContext: ModelContext {
    guard let modelContext = try? self.databaseService.context() else {
      fatalError("Could not find modelcontext")
    }
    return modelContext
  }

  static let store = Store(initialState: TabBreedFeature.State()) {
    TabBreedFeature()
      ._printChanges()
  }

  @StateObject var networkMonitor = NetworkMonitor()

  var body: some Scene {
    WindowGroup {
      BreedTabView(store: FidoAppApp.store)
        .environmentObject(networkMonitor)
    }
    .modelContext(self.modelContext)
  }
}
