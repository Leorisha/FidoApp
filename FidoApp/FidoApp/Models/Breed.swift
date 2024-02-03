//
//  Breed.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import Foundation

struct Breed: Equatable, Identifiable, Decodable {
  var id: Int
  var breedName: String
  var breedGroup: String?
  var temperament: String?
  var imageUrl: String

  private enum CodingKeys: String, CodingKey {
    case id
    case breedName = "name"
    case breedGroup = "breed_group"
    case temperament
    case imageUrl = "reference_image_id"
  }


  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    breedName = try container.decode(String.self, forKey: .breedName)
    breedGroup = try? container.decode(String.self, forKey: .breedGroup)
    temperament = try? container.decode(String.self, forKey: .temperament)
    let reference = try container.decode(String.self, forKey: .imageUrl)
    imageUrl = "https://cdn2.thedogapi.com/images/\(reference).jpg"  }
}
