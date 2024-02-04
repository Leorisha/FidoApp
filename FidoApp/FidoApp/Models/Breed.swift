//
//  Breed.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import Foundation

struct Breed: Equatable, Identifiable, Decodable, Hashable {
  var id: Int
  var name: String
  var group: String?
  var origin: String?
  var category: String?
  var temperament: String?
  var imageUrl: String

  private enum CodingKeys: String, CodingKey {
    case id
    case name
    case group = "breed_group"
    case category = "bred_for"
    case origin = "country_code"
    case temperament
    case imageUrl = "reference_image_id"
  }

  init(id: Int, name: String, group: String?, category: String?, origin: String?, temperament: String?, imageUrl: String) {
    self.id = id
    self.name = name
    self.group = group
    self.origin = origin
    self.category = category
    self.temperament = temperament
    self.imageUrl = imageUrl
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    group = try? container.decode(String.self, forKey: .group)
    category = try? container.decode(String.self, forKey: .category)
    temperament = try? container.decode(String.self, forKey: .temperament)
    let reference = try container.decode(String.self, forKey: .imageUrl)
    imageUrl = "https://cdn2.thedogapi.com/images/\(reference).jpg"  }

  static func mock() -> Breed {
    return Breed(
      id: 1,
      name: "Sample Breed",
      group: "Sample Group",
      category: "Sample Category",
      origin: "US",
      temperament: "Friendly",
      imageUrl: "https://cdn2.thedogapi.com/images/HkNS3gqEm.jpg"
    )
  }
}
