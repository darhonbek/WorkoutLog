//
//  UIViewControllerExtension.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 923//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func closePopUpWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.closeVC))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func closeVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
