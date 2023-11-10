//
//  User.swift
//  PhotoLibrary
//
//  Created by Дмитрий Абдуллаев on 26.06.2023.
//

import Foundation

class User: Codable {
  var photo: String
  var text: String
  var isLiked: Bool = false
  
  init(photo: String, text: String) {
       self.photo = photo
       self.text = text
   }
   
   private enum CodingKeys: String, CodingKey {
       case photo
       case text
       case isLiked
   }
   
  required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      
    photo = try container.decode(String.self, forKey: .photo)
    text = try container.decode(String.self, forKey: .text)
    isLiked = try container.decode(Bool.self, forKey: .isLiked)
  }
  
  func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      
    try container.encode(photo, forKey: .photo)
    try container.encode(text, forKey: .text)
    try container.encode(isLiked, forKey: .isLiked)
  }
}
  
