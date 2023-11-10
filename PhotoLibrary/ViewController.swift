//
//  ViewController.swift
//  PhotoLibrary
//
//  Created by Дмитрий Абдуллаев on 25.06.2023.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var buttonLogIn: UIButton!
  @IBOutlet weak var buttonRegister: UIButton!
  private let alert = Custom.instanceMethod()
  private var register = RegisterViewController()

  override func viewDidLoad() {
    super.viewDidLoad()
    buttonLogIn.layer.cornerRadius = 10
    buttonRegister.layer.cornerRadius = 10
    buttonLogIn.layer.borderWidth = 2
    buttonRegister.layer.borderWidth = 2
  }

  @IBAction func registerButton(_ sender: UIButton) {
    guard let settings = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as?  RegisterViewController else { return }
        navigationController?.pushViewController(settings, animated: true)
  }
  
  @IBAction func logInButton(_ sender: UIButton) {
    alert.layerButton()
    alert.frame = CGRect(origin: self.view.frame.origin, size: self.view.frame.size)
    view.addSubview(alert)
    alert.okButton.addTarget(self, action: #selector(showCollectionController), for: .touchUpInside)
    }
  
  @IBAction private func showCollectionController() {
    if alert.textFiield.text == register.defaults as? String {
      guard let showCollectionController = storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController else {return}
      navigationController?.pushViewController(showCollectionController, animated: true)
    } else {
      UIView.animate(withDuration: 0.1) {
        self.alert.textFiield.frame.origin.x += 10
      } completion: { _ in
        self.alert.textFiield.frame.origin.x -= 10
      }
    }
  }
}

