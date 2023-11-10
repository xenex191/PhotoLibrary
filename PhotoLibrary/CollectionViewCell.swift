//
//  CollectionViewCell.swift
//  PhotoLibrary
//
//  Created by Дмитрий Абдуллаев on 11.08.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  
  func configure(image: UIImage?) {
    imageView.image = image
  }
  
  func loadImage(fileName: String) -> UIImage? {
    if let documentsDirectory = FileManager.default.urls (for: .documentDirectory, in: .userDomainMask).first {
      let imageUrl = documentsDirectory.appendingPathComponent(fileName)
      let image = UIImage (contentsOfFile: imageUrl.path)
      return image
    }
    return nil
  }
}
