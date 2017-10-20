//
//  EditlogTableViewController.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 13/10/17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import UIKit
import CoreData

class EditLogViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var repsTextField: CustomTextField!
    @IBOutlet weak var weightTextField: CustomTextField!
    public var context: NSManagedObjectContext?
    public var setLog: SetLog?
    private var activeField: UITextField?
    private var reps: Int32? {
        get {
            if let text = repsTextField.text {
                return Int32(text)
            } else {
                return nil
            }
        }
    }
    private var weight: Int32? {
        get {
            if let text = weightTextField.text {
                return Int32(text)
            } else {
                return nil
            }
        }
    }
    @IBAction func saveData(_ sender: UIBarButtonItem) {
        if let unwrappedWeight = weight,
            let unwrappedReps = reps {
            setLog?.reps = unwrappedReps
            setLog?.weight = unwrappedWeight
        }
        try? context?.save()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadExercises"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelEditing(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        self.hideKeyboardWhenTappedAround()
        setupTextFields()
    }
    
    
    private func updateUI() {
        repsTextField.text = setLog?.reps.description
        weightTextField.text = setLog?.weight.description
    }
    
    //MARK: - Managing keyboard
    private func setupTextFields() {
        repsTextField.tag = 1
        weightTextField.tag = 2
        repsTextField.delegate = self
        weightTextField.delegate = self
        createToolBarForTextField(repsTextField)
        createToolBarForTextField(weightTextField, withButton: "Done")
    }
    
    func createToolBarForTextField(_ textField: UITextField, withButton buttonTitle: String = "Next") {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: buttonTitle, style: .plain, target: self, action: #selector(EditLogViewController.findNextResponder))
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([space, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == repsTextField {
            weightTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            if !(repsTextField.text?.isEmpty)! && !(weightTextField.text?.isEmpty)! {
                saveData(saveButton)
            }
        }
        return false
    }
    
    @objc func findNextResponder() {
        if let textField = activeField {
            let _ = textFieldShouldReturn(textField)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        textField.text = ""
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
}





















