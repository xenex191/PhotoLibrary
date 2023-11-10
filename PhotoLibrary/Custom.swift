//
//  Custom.swift
//  PhotoLibrary
//
//  Created by Дмитрий Абдуллаев on 27.06.2023.
//

import UIKit

class Custom: UIView {
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var textFiield: UITextField!
  @IBOutlet weak var view: UIImageView!
  @IBOutlet weak var cancelButtom: UIButton!
  @IBOutlet weak var okButton: UIButton!
  
  static func instanceMethod() -> Custom {
    return UINib(nibName: "Custom", bundle: nil).instantiate(withOwner: nil,options: nil)[0] as! Custom
  }
  
 func layerButton(){
    view.layer.cornerRadius = 12
    cancelButtom.layer.borderWidth = 1
    okButton.layer.borderWidth = 1
    backgroundView.alpha = 0.3
  }
  
 func removeAll(){
    UIView.animate(withDuration: 0.1) {
    } completion: { _ in
      self.removeFromSuperview()
    }
   
  func textPassword(text: String) {
    textFiield.text = text
   }
    
  }
  @IBAction func cancel(_ sender: UIButton) {
  removeAll()
  }
}
