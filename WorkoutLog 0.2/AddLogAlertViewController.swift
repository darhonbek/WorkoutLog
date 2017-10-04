//
//  AddLogAlertViewController.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 104//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import Foundation
import UIKit

class AddLogAlertViewController: UIAlertController {
    @IBAction func addButtonClicked(_ sender: UIButton){
        
        let alertController = UIAlertController(title: "Add New Name", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            print("firstName \(firstTextField.text), secondName \(secondTextField.text)")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter First Name"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Second Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
