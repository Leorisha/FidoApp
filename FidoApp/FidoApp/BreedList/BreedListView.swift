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
    NavigationView {
      VStack {
        self.pickerView()
        Group {
          if store.selectedView == .list {
            self.listView()
          } else {
            self.gridView()
          }
        }
        Button("Load More") {
          store.send(.loadMore)
        }
      }

    }
    .navigationTitle("Breeds")
    .onAppear() {
      store.send(.fetchBreeds(page: store.currentPage, limit: store.itemsPerPage))
    }
    .padding()
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
    return   List {
      ForEach(store.breeds.prefix(store.currentPage * store.itemsPerPage), id: \.self) { breed in
        HStack {
          AsyncImage(url: URL(string: breed.imageUrl)) { phase in
                      switch phase {
                      case .empty:
                          ProgressView()
                      case .success(let image):
                          image
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                      case .failure:
                          Text("Failed to load image")
                      @unknown default:
                          EmptyView()
                      }
                  }
                  .frame(width: 100, height: 100)
          Text(breed.breedName)
        }
      }
    }

  }

  private func gridView()-> some View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    return ScrollView{
      LazyVGrid(columns: columns, spacing: 16) {
        ForEach(store.breeds.prefix(store.currentPage * store.itemsPerPage), id: \.self) { breed in
          RoundedRectangle(cornerRadius: 10)
            .frame(height: 150)
            .overlay(
              VStack {
                AsyncImage(url: URL(string: breed.imageUrl)) { phase in
                  switch phase {
                  case .empty:
                    ProgressView()
                  case .success(let image):
                    image
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                  case .failure:
                    Text("Failed to load image")
                  @unknown default:
                    EmptyView()
                  }
                }
                .frame(width: 100, height: 100)
                Text(breed.breedName)
                  .foregroundColor(.white)
              }
            )
            .foregroundColor(.gray)
        }
      }
    }
    .padding()
  }
}

#Preview {
  BreedListView(store: Store(initialState: BreedListFeature.State()) {
    BreedListFeature()
  }
  )
}
