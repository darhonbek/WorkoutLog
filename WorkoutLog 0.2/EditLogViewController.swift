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
    
    
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    public var context: NSManagedObjectContext?
    public var setLog: SetLog?
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
        repsTextField.delegate = self
        weightTextField.delegate = self
        updateUI()
    }
    
    private func updateUI() {
        repsTextField.text = setLog?.reps.description
        weightTextField.text = setLog?.weight.description
    }
}
