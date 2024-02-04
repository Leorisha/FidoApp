//
//  FidoAppApp.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct FidoAppApp: App {

  static let store = Store(initialState: TabBreedFeature.State()) {
    TabBreedFeature()
      ._printChanges()
  }

    var body: some Scene {
        WindowGroup {
          BreedTabView(store: FidoAppApp.store)
        }
    }
}
