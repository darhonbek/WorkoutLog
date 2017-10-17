//
//  AlertHelper.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 1011//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {
    func showAlert(fromController controller: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.present(alert, animated: true, completion: nil)
    }
}
