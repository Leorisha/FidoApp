//
//  BreedDetailView.swift
//  FidoApp
//
//  Created by Ana Neto on 04/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct BreedDetailView: View {

  let store: StoreOf<BreedDetailFeature>

    var body: some View {
      VStack {
        HStack {
          Text("Category:")
            .bold()
          Text(store.breed.category ?? "No information")
          Spacer()
        }
        .padding([.leading])
        HStack {
          Text("Group:")
            .bold()
          Text(store.breed.group ?? "No information")
          Spacer()
        }
        .padding([.leading])
        HStack {
          Text("Origin:")
            .bold()
          Text(store.breed.origin ?? "No information")
          Spacer()
        }
        .padding([.leading])
        HStack {
          Text("Temperament:")
            .bold()
          Text(store.breed.temperament ?? "No information")
          Spacer()
        }
        .padding([.leading])

        Spacer()
      }

      .navigationTitle("\(store.breed.name)")
    }
}

#Preview {
  NavigationStack {
    BreedDetailView(store: Store(initialState: BreedDetailFeature.State(breed: Breed.mock())) {
      BreedDetailFeature()
    })
  }
}
