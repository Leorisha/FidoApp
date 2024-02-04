//
//  ContentView.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct BreedListView: View {

  @Bindable var store: StoreOf<BreedListFeature>

  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      VStack {

        self.pickerView()

        Group {
          if store.selectedView == .list {
            self.listView()
          } else {
            self.gridView()
          }
        }

        if store.isLoading {
          ProgressView()
        } else if store.shouldShowError {
          VStack {
            Text("Error occurred")
            Button("Retry") {
              store.send(.retry)
            }
          }
        } else {
          HStack {
            Button("-") {
              store.send(.minusPage)
            }
            Text("\(store.currentPage) / \(store.totalPages)")
            Button("+") {
              store.send(.plusPage)
            }
           }
        }

      }
      .navigationTitle("Breeds")
    }
  destination: { store in
    BreedDetailView(store: store)
  }
  .onAppear() {
    if store.breeds.isEmpty {
      store.send(.fetchOfflineBreeds)
    }
  }
  }

  private func pickerView() -> some View {
    return Picker("", selection: $store.selectedView.sending(\.setSelection)) {
      ForEach(BreedListFeature.ViewType.allCases, id: \.self) {
        Text($0.rawValue)
      }
    }
    .pickerStyle(.segmented)
    .padding()
  }

  private func listView()-> some View {
    return ScrollView {
      ForEach(store.displayingBreeds, id: \.self) { breed in
        NavigationLink(state: BreedDetailFeature.State(breed: breed)){
          self.tableViewCell(for: breed)
            .padding()
        }
      }
    }
  }

  private func gridView()-> some View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    return ScrollView{
      LazyVGrid(columns: columns, spacing: 16) {
        ForEach(store.displayingBreeds, id: \.self) { breed in
          NavigationLink(state: BreedDetailFeature.State(breed: breed)){
            gridCell(for: breed)
          }
        }
      }
    }
    .padding()
  }

  private func tableViewCell(for breed: Breed) -> some View {
    return HStack {
      CachedImageView(imageUrl: URL(string: breed.imageUrl))
      .frame(maxWidth: 100, maxHeight: 100)
      Text(breed.name)
      Spacer()
    }
    .foregroundColor(.black)
  }

  private func gridCell(for breed: Breed) -> some View {
    return VStack {
      CachedImageView(imageUrl: URL(string: breed.imageUrl))
      .frame(maxWidth: 100, maxHeight: 100)
      Text(breed.name)
        .multilineTextAlignment(.center)
        .padding()
    }
    .foregroundColor(.black)
  }

}

#Preview {
  BreedListView(store: Store(initialState: BreedListFeature.State()) {
    BreedListFeature()
  }
  )
}
