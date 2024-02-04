//
//  BreedDatabase.swift
//  FidoApp
//
//  Created by Ana Neto on 04/02/2024.
//

import Foundation
import SwiftData
import ComposableArchitecture

extension DependencyValues {
    var swiftData: BreedDatabase {
        get { self[BreedDatabase.self] }
        set { self[BreedDatabase.self] = newValue }
    }
}

struct BreedDatabase {
    var fetchAll: @Sendable () throws -> [Breed]
    var fetch: @Sendable (FetchDescriptor<Breed>) throws -> [Breed]
    var add: @Sendable ([Breed]) throws -> Void

    enum MovieError: Error {
        case add
        case delete
    }
}

extension BreedDatabase: DependencyKey {
    public static let liveValue = Self(
        fetchAll: {
            do {
                @Dependency(\.databaseService.context) var context
                let breedContext = try context()

                let descriptor = FetchDescriptor<Breed>(sortBy: [SortDescriptor(\.name)])
                let values = try breedContext.fetch(descriptor)

              for value in values {
                print("DB \(value.name)")
              }
                return values
            } catch {
                return []
            }
        },
        fetch: { descriptor in
            do {
                @Dependency(\.databaseService.context) var context
                let breedContext = try context()
                return try breedContext.fetch(descriptor)
            } catch {
                return []
            }
        },
        add: { models in
            do {
                @Dependency(\.databaseService.context) var context
                let breedContext = try context()

              for model in models {
                print("DB INSERT \(model.name)")
                breedContext.insert(model)
              }

              try breedContext.save()
            } catch {
                throw MovieError.add
            }
        }
    )
}

