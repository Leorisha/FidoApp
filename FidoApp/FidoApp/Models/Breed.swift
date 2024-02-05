//
//  Breed.swift
//  FidoApp
//
//  Created by Ana Neto on 03/02/2024.
//

import Foundation
import SwiftData

@Model
class Breed: Codable, Equatable, Identifiable, Hashable {
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
    case origin
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

  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let id = try container.decode(Int.self, forKey: .id)
    let name = try container.decode(String.self, forKey: .name)
    let group = try? container.decode(String.self, forKey: .group)
    let origin = try? container.decode(String.self, forKey: .origin)
    let category = try? container.decode(String.self, forKey: .category)
    let temperament = try? container.decode(String.self, forKey: .temperament)
    let reference = try container.decode(String.self, forKey: .imageUrl)
    let imageUrl = "https://cdn2.thedogapi.com/images/\(reference).jpg"

    self.init(id: id, name: name, group: group, category: category, origin: origin, temperament: temperament, imageUrl: imageUrl)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(group, forKey: .group)
    try container.encode(origin, forKey: .origin)
    try container.encode(category, forKey: .category)
    try container.encode(temperament, forKey: .temperament)
    let reference = imageUrl.components(separatedBy: "/").last?.replacingOccurrences(of: ".jpg", with: "")
    try container.encode(reference, forKey: .imageUrl)
  }

  static func ==(lhs: Breed, rhs: Breed) -> Bool {
    return lhs.id == rhs.id &&
           lhs.name == rhs.name &&
           lhs.group == rhs.group &&
           lhs.origin == rhs.origin &&
           lhs.category == rhs.category &&
           lhs.temperament == rhs.temperament &&
           lhs.imageUrl == rhs.imageUrl
  }

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
