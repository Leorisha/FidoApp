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

  static let store = Store(initialState: BreedListFeature.State()) {
    BreedListFeature()
      ._printChanges()
  }

    var body: some Scene {
        WindowGroup {
          BreedListView(store: FidoAppApp.store)
        }
    }
}
