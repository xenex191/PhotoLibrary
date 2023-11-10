//
//  RegisterViewController.swift
//  PhotoLibrary
//
//  Created by Дмитрий Абдуллаев on 26.06.2023.
//

import UIKit

class RegisterViewController: UIViewController{
  
  @IBOutlet weak var nameText: UITextField!
  @IBOutlet weak var passwordText: UITextField!
  @IBOutlet weak var passwordRepeat: UITextField!
  @IBOutlet weak var registerButton: UIButton!
  let defaults = UserDefaults.standard.value(forKey: "password")
  var didSave = false {
    didSet {
      save()
      saveName()
      passwordText.isEnabled = false
      passwordRepeat.isEnabled = false
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let gesture = UITapGestureRecognizer(target: self, action:#selector(textFieldDidEndEditing(_:)))
    self.view.addGestureRecognizer(gesture)
    
    load()
    loadName()
    registerButton.layer.cornerRadius = 10
    registerButton.layer.borderWidth = 2
  }
  @IBAction func registerButton(_ sender: UIButton) {
    if passwordText.text == passwordRepeat.text && passwordText.text != "" {
      guard let viewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as?  ViewController else { return }
      navigationController?.pushViewController(viewController, animated: true)
      didSave = true
    } else {
      alert(title: "Symbols aren't correct", message: "try again")
    }
  }
  
  private func load() {
    guard let data =  defaults as? String else {return}
    passwordText.text = data
    passwordRepeat.text = data
  }
  
  private func save() {
    UserDefaults.standard.set(passwordText.text, forKey: "password")
  }
  
  private func saveName() {
    UserDefaults.standard.set(nameText.text, forKey: "name")
    UserDefaults.standard.set(didSave, forKey: "bool")
  }
  
  private func loadName(){
    guard let load = UserDefaults.standard.value(forKey: "name") as? String else {return}
    nameText.text = load
    
    guard let load = UserDefaults.standard.value(forKey: "bool") as? Bool else {return}
    didSave = load
  }
  
@IBAction func textFieldDidEndEditing(_ textField: UITextField) {
      passwordText.resignFirstResponder()
      passwordRepeat.resignFirstResponder()
      nameText.resignFirstResponder()
  }
}
