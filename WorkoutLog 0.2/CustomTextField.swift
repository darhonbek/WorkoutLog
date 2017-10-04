//
//  CustomTextField.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 104//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
