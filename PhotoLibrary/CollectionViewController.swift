//
//  CollectionViewController.swift
//  PhotoLibrary
//
//  Created by Дмитрий Абдуллаев on 28.06.2023.
//

import UIKit

class CollectionViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var array: [User] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    array = UserDefaults.standard.value([User].self, forKey: Keys.photos.rawValue) ?? []
    collectionView.reloadData()
  }
  
  @IBAction func backButton(_ sender: UIButton) {
    guard let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @IBAction func showPhoto(_ sender: UIButton) {
    guard let showPhoto = storyboard?.instantiateViewController(withIdentifier: "ShowPhotosViewController") as? ShowPhotosViewController else { return }
        navigationController?.pushViewController(showPhoto, animated: true)
  }
  @IBAction func addPhoto(_ sender: UIButton) {
    guard let addPhoto = storyboard?.instantiateViewController(withIdentifier: "AddPhotoViewController") as? AddPhotoViewController else { return }
        navigationController?.pushViewController(addPhoto, animated: true)
  }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    array.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell
    else {return UICollectionViewCell()}
    cell.configure(image: cell.loadImage(fileName: array[indexPath.item].photo))
    cell.layer.cornerRadius = CGFloat(15)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedPhoto = array[indexPath.item].photo
    guard let showPhoto = storyboard?.instantiateViewController(withIdentifier: "ShowPhotosViewController") as? ShowPhotosViewController else { return }
        showPhoto.selectedPhotoName = selectedPhoto
        navigationController?.pushViewController(showPhoto, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 15
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let side = (collectionView.frame.width - 15) / 2
    return CGSize(width: side, height: side)
  }
  
}
    
  

