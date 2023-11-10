//
//  AddPhotoViewController.swift
//  PhotoLibrary
//
//  Created by Дмитрий Абдуллаев on 28.06.2023.
//

import UIKit

class AddPhotoViewController: UIViewController {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var viewImage: UIImageView!
  @IBOutlet weak var blurView: UIVisualEffectView!
  
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  override func viewDidLoad() {
    super.viewDidLoad()
    viewImage.layer.cornerRadius = 20
    blurView.layer.cornerRadius = 20
    registerForKeyboardNotifications()
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
  
  @IBAction func saveButton(_ sender: UIButton) {
    guard let image = viewImage.image,
          let text = textField.text,
          let imageName = saveImage(image: image) else {
      alert(title: "Error", message: "Empty image or text")
      return
    }
    
    var photos = UserDefaults.standard.value([User].self, forKey: Keys.photos.rawValue) ?? []
    let photo = User(photo: imageName, text: text)
    photos.append(photo)
    UserDefaults.standard.set(encodable: photos, forKey: Keys.photos.rawValue)
    
    resetUI()
    alert(title: "Success", message: "Photo saved!")
  }
  
  func resetUI() {
    viewImage.image = nil
    textField.text = ""
    blurView.isHidden = false
  }
  
  
  @IBAction func backButton(_ sender: UIButton) {
    guard let controller = storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController else {return}
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @IBAction func addImage(_ sender: UIButton) {
    let alert = UIAlertController(title: "Add photo", message: "choose source", preferredStyle: .actionSheet)
    let alertCamera = UIAlertAction(title: "Camera", style: .default) { _ in
      self.showPicker(source: .camera)
    }
    let alertLibrary = UIAlertAction(title: "Library", style: .default) { _ in
      self.showPicker(source: .photoLibrary)
    }
    alert.addAction(alertCamera)
    alert.addAction(alertLibrary)
    present(alert, animated: true)
  }
  
  private func showPicker(source: UIImagePickerController.SourceType) {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.sourceType = source
    picker.delegate = self
    present(picker, animated: true, completion: nil)
  }
  
  func saveImage(image: UIImage) -> String? {
    guard let documentsDirectory = FileManager.default.urls (for: .documentDirectory, in: .userDomainMask).first else { return nil}
    let fileName = UUID().uuidString
    let fileURL = documentsDirectory.appendingPathComponent (fileName)
    guard let data = image.jpegData(compressionQuality: 1) else { return nil}
    
    if FileManager.default.fileExists(atPath: fileURL.path) {
      
      do {
        try FileManager.default.removeItem(atPath: fileURL.path)
        print( "Removed old image")
      } catch let error {
        print("couldn't remove file at path", error)
      }
    }
    do {
      try data.write(to: fileURL)
      return fileName
    } catch let error {
      print("error saving file with error", error)
      return nil
    }
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

extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    var choesen = UIImage()
    
    if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      choesen = image
    } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      choesen = image
    }
    viewImage.image = choesen
    blurView.isHidden = true
    picker.dismiss(animated: true)
  }
}
extension AddPhotoViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
}


