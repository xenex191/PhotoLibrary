//
//  ShowPhotosViewController.swift
//  PhotoLibrary
//
//  Created by Дмитрий Абдуллаев on 28.06.2023.
//
import UIKit

class ShowPhotosViewController: UIViewController {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var viewImage: UIImageView!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  var imageArary: [User]?
  var selectedPhotoName: String?
  private var index = 0
  private var quontityImages = 1   {
    didSet {
      if quontityImages < 1 {
        alert(title: "No photos left", message: "Do not forget to add some") {
          self.navigationController?.popViewController(animated: true)
        }
      }
    }
  }
  private var isLiked: Bool = false {
    didSet {
      if isLiked == false {
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
      } else {
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadData()
    registerForKeyboardNotifications()
    viewImage.layer.cornerRadius = 20
}

private func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
}

@objc private func keyboardWillShow(_ notification: NSNotification) {
    guard let userInfo = notification.userInfo,
          let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
          let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      bottomConstraint.constant = 0
    } else {
        bottomConstraint.constant = keyboardScreenEndFrame.height + 10
    }
    
    view.needsUpdateConstraints()
    UIView.animate(withDuration: animationDuration) {
        self.view.layoutIfNeeded()
    }
}
  
  @IBAction func rightButton(_ sender: UIButton) {
    updateData()
    index = index < quontityImages - 1 ? index + 1: 0
    guard index > 1 else {return}
    guard let photos = imageArary else {return}
    
    let slideView = UIImageView()
    slideView.frame = CGRect(x: self.view.frame.width, y: viewImage.frame.origin.y, width: viewImage.frame.width, height: viewImage.frame.height)
    slideView.layer.cornerRadius = 20
    let photo = photos[index]
    guard let image = self.loadImage(fileName: photo.photo) else {return}
    slideView.image = image
    textField.text = photo.text
    isLiked = photo.isLiked
    likeButton.alpha = 0
    view.addSubview(slideView)
    
    UIView.animate(withDuration: 0.3) {
      slideView.frame.origin.x = self.viewImage.frame.origin.x
      self.likeButton.alpha = 1
    } completion: { _ in
      self.viewImage.image = image
      slideView.removeFromSuperview()
    }
  }
  
  @IBAction func leftButton(_ sender: UIButton) {
    updateData()
    index = index > 0 ? index - 1 :quontityImages - 1
    guard index > 1 else {return}
    guard let photos = imageArary else {return}
    let photo = photos[index]
    let slideView = UIImageView()
    slideView.frame = CGRect(origin: viewImage.frame.origin, size: viewImage.frame.size)
    slideView.layer.cornerRadius = 20
    slideView.image = viewImage.image
    viewImage.image = loadImage(fileName: photo.photo)
    textField.text = photo.text
    isLiked = photo.isLiked
    likeButton.alpha = 0
    view.addSubview(slideView)
    
    UIView.animate(withDuration: 0.3) {
      slideView.frame.origin.x = -self.view.frame.width
      self.likeButton.alpha = 1
    } completion: { _ in
      slideView.removeFromSuperview()
    }
  }
  
  @IBAction func deleteButton(_ sender: UIButton) {
    alert(title: "Delete photo", message: "Are you sure?") {
      self.delete()
    }
  }
  
  private func loadData() {
    if let selectedPhotoName = selectedPhotoName {
      if let image = loadImage(fileName: selectedPhotoName) {
        viewImage.image = image
      }
    }
    if let photos = UserDefaults.standard.value([User].self, forKey: Keys.photos.rawValue) {
      imageArary = photos
      quontityImages = photos.count
      guard let photo = photos.first else {return}
      isLiked = photo.isLiked
      textField.text = photo.text
    //  let imageName = photo.photo
    //  guard let image = loadImage(fileName: imageName) else {return}
    //  viewImage.image = image
    } else {
      quontityImages = 0
    }
  }
  
  private func updateData() {
    guard let photo = imageArary?[index] else {return}
    guard let text = textField.text else {return}
    photo.text = text
    photo.isLiked = isLiked
    
    UserDefaults.standard.set(encodable: imageArary, forKey: Keys.photos.rawValue)
  }
  
  private func delete() {
    guard let photo = imageArary?[index] else {return}
    imageArary = imageArary?.filter({ $0.photo != photo.photo })
    
    UserDefaults.standard.set(encodable: imageArary, forKey: Keys.photos.rawValue)
    quontityImages -= 1
    
    index = index < quontityImages - 1 ? index + 1: 0
    
    guard quontityImages > 0 else {return}
    guard let photos = imageArary else {return}
    
    let slideView = UIImageView()
    slideView.frame = CGRect(x: self.view.frame.width, y: viewImage.frame.origin.y, width: viewImage.frame.width, height: viewImage.frame.height)
    
    let nextPhoto = photos[index]
    guard let image = loadImage(fileName: nextPhoto.photo) else {return}
    slideView.image = image
    isLiked = nextPhoto.isLiked
    textField.text = nextPhoto.text
    
    view.addSubview(slideView)
    likeButton.alpha = 0
    
    UIView.animate(withDuration: 0.3) {
      slideView.frame.origin.x = self.viewImage.frame.origin.x
      self.likeButton.alpha = 1
    } completion: { _ in
      self.viewImage.image = image
      slideView.removeFromSuperview()
    }
  }
  
  @IBAction func likeButtonAction(_ sender: UIButton) {
    isLiked = !isLiked
  }
  
  @IBAction func backButton(_ sender: UIButton) {
    updateData()
    guard let controller = storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController else {return}
    self.navigationController?.pushViewController(controller, animated: true)
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
extension ShowPhotosViewController: UITextFieldDelegate{
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
}
