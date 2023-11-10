//
//  Extension.swift
//  PhotoLibrary
//
//  Created by Дмитрий Абдуллаев on 29.06.2023.
//

import UIKit

extension UIViewController {
  func alert(title: String, message: String, cancelActionTitle: String = "Cancel", cancelActionHandler: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .destructive) { _ in
      cancelActionHandler?()
    }

    let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel) 
    alert.addAction(cancelAction)
    alert.addAction(alertAction)
    present(alert, animated: true)
  }
  }
