//
//  SearchBreedView.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct BreedSearchView: View {

  @Bindable var store: StoreOf<BreedSearchFeature>
  @FocusState private var searchIsFocused: Bool

  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      VStack {
        self.searchBar()
        if store.searchResults.isEmpty {
          if store.isLoading {
            VStack {
              Spacer()
              ProgressView()
              Spacer()
            }
          } else if store.shouldShowError {
            VStack {
              Spacer()
              Text("Error occurred")
              Button("Retry") {
                store.send(.retry)
              }
            }
          } else {
            ContentUnavailableView.search
          }

        } else {
          listView()
        }
      }
      .onAppear() {
        if store.allBreeds.isEmpty {
          store.send(.fetchOfflineBreeds)
        }
      }
      .navigationTitle("Search")
    }
  destination: { store in
    BreedDetailView(store: store)
  }
  }

  private func searchBar()-> some View  {
    return HStack {
      TextField("Search for a breed name", text: $store.searchText.sending(\.updateText), onCommit: searchAction)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .focused($searchIsFocused)
        .padding(.horizontal)

      Button(action: searchAction) {
        Text("Search")
      }
      .padding(.trailing)
    }
  }

  private func listView()-> some View  {
    return ScrollView {
      ForEach(store.searchResults, id: \.self) { breed in
        NavigationLink(state: BreedDetailFeature.State(breed: breed)){
          self.tableViewCell(for: breed)
            .padding()
        }
      }
    }
  }

  private func tableViewCell(for breed: Breed) -> some View {
    return VStack {
      HStack {
        Text("Breed: ").bold()
        Text(breed.name)
          .bold()
        Spacer()
      }
      HStack {
        Text("Group: ").bold()
        Text(breed.group ?? "No Information")
        Spacer()
      }
      HStack {
        Text("Origin: ").bold()
        Text(breed.origin ?? "No Information")
        Spacer()
      }
      Spacer()
    }
    .foregroundColor(.black)
  }

  private func searchAction() {
    searchIsFocused = false
    store.send(.performSearch(store.searchText))
  }
}

#Preview {
  NavigationStack {
    BreedSearchView(store: Store(initialState: BreedSearchFeature.State()) {
      BreedSearchFeature()
    })
  }
}
