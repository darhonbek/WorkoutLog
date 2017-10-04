//
//  AddLogPopUpViewController.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 916//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications

class AddLogPopUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var muscleTextField: CustomTextField!
    @IBOutlet weak var exerciseTextField: CustomTextField!
    @IBOutlet weak var repsTextField: CustomTextField!
    @IBOutlet weak var weightTextField: CustomTextField!
    
    @IBOutlet weak var musclePicker: UIPickerView!
    @IBOutlet weak var exercisePicker: UIPickerView!
    
    static var recentPickedMuscle: String?
    static var recentPickedExercise: String?
    
    public var dayLog: DayLog?
    var activeField: UITextField?
    var muscleList:[String] = [String]()
    var exerciseList:[String] {
        get {
            return Database.muscles[pickedMuscle]!
        }
    }
    var pickedMuscle:String = String()
    
    private var reps: Int32 {
        get {
            return Int32(repsTextField.text!) ?? 0
        }
    }
    private var weight: Int32 {
        get {
            return Int32(weightTextField.text!) ?? 0
        }
    }
    private var muscleName: String? {
        get {
            return muscleTextField.text
        }
    }
    private var exerciseName: String? {
        get {
            return exerciseTextField.text
        }
    }
    
    //MARK: Data initialization
    func initMuscleList() {
        Database.loadData()
        for (key, _) in Database.muscles {
            muscleList.append(key)
        }
        pickedMuscle = muscleList[0]
    }
    
    private func initTextFieldTags() {
        muscleTextField.tag = 1
        exerciseTextField.tag = 2
        repsTextField.tag = 3
        weightTextField.tag = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        initTextFieldTags()
        
        initMuscleList()
        
        doneButton.addBorder(side: .Top, color: .lightGray, width: 1.0)
        
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        
        muscleTextField.delegate = self
        exerciseTextField.delegate = self
        repsTextField.delegate = self
        weightTextField.delegate = self
        
        musclePicker.delegate = self
        musclePicker.dataSource = self
        exercisePicker.delegate = self
        exercisePicker.dataSource = self
        muscleTextField.inputView = musclePicker
        exerciseTextField.inputView = exercisePicker
        
        createToolBarForTextField(muscleTextField)
        createToolBarForTextField(exerciseTextField)
        createToolBarForTextField(repsTextField)
        createToolBarForTextField(weightTextField, withButton: "Done")
        
        loadRecentLog()
    }
    
    //Reloads recently memorized Log
    func loadRecentLog() {
        if let muscle = AddLogPopUpViewController.recentPickedMuscle,
            let exercise = AddLogPopUpViewController.recentPickedExercise {
            muscleTextField.text = muscle
            exerciseTextField.text = exercise
            repsTextField.becomeFirstResponder()
        }
    }
    
    //Memorizes last added log
    func updateRecentLog(muscle: String, exercise: String) {
        AddLogPopUpViewController.recentPickedMuscle = muscle
        AddLogPopUpViewController.recentPickedExercise = exercise
    }
    
    //MARK: - Adding new log
    @IBAction func closePopUp(_ sender: UIButton) {
        if !(muscleTextField.text?.isEmpty)! &&
            !(exerciseTextField.text?.isEmpty)! &&
            !(repsTextField.text?.isEmpty)! &&
            !(weightTextField.text?.isEmpty)! {
            
            let context = AppDelegate.viewContext
            do {
                if let muscleName = muscleName,
                    let exerciseName = exerciseName,
                    let unwrappedDayLog = dayLog {
                    let _ = try? ExerciseLog.modifyOrCreateExerciseLog(named: exerciseName, reps: reps, weight: weight, dayLog: unwrappedDayLog, in: context)
                    let _ = try? MuscleLog.findOrCreateMuscleLog(dayLog: unwrappedDayLog, named: muscleName, in: context)
                    updateRecentLog(muscle: muscleName, exercise: exerciseName)
                }
                try context.save()
                //reload data in DayTableViewController
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadExercises"), object: nil)
            }
            catch {
                print (error)
            }
            dismiss(animated: true, completion: nil)
        } else {
            //Notify user about incompleted text fields
            alert()
        }
    }
    
    //MARK: Configuring TOOLBARS for Text Fields
    func createToolBarForTextField(_ textField: UITextField, withButton buttonTitle: String = "Next") {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: buttonTitle, style: .plain, target: self, action: #selector(AddLogPopUpViewController.findNextResponder))
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([space, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
    }
    
    //MARK: Managing keyboard
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
//    disables textfield manual changing
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == muscleTextField || textField == exerciseTextField {
            return false
        }
        return true
    }
    
    @objc func findNextResponder() {
        if let textField = activeField {
            let _ = textFieldShouldReturn(textField)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTage=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
            closePopUp(doneButton)
        }
        return false
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = activeField {
            if (!aRect.contains(activeField.frame.origin)){
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        view.endEditing(true)
        scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        textField.text = ""
        if textField == muscleTextField {
            exerciseTextField.text = ""
            if (textField.text?.isEmpty)! {
                textField.text = muscleList[0]
            }
        }
        if textField == exerciseTextField && (exerciseTextField.text?.isEmpty)! && !(muscleTextField.text?.isEmpty)!{
            textField.text = exerciseList[0]
        }
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    //MARK: End managing keyboard
}

//MARK: Configuring the Exercise UIPickerView
extension AddLogPopUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case exercisePicker:
            return exerciseList.count
        case musclePicker:
            return muscleList.count
        default:
            print("Logical bug in AddLogPopUpViewController, numberOfRowsInComponent")
            return 0
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case exercisePicker:
            return exerciseList[row]
        case musclePicker:
            return muscleList[row]
        default:
            print("Logical bug in AddLogPopUpViewController, titleForRow")
            return "Eror-Logical, see log"
        }
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case exercisePicker:
            exerciseTextField.text = exerciseList[row]
        case musclePicker:
            pickedMuscle = muscleList[row]
            muscleTextField.text = muscleList[row]
        default:
            print("Logical bug in AddLogPopUpViewController, didSelectRow")
        }
    }
    
    //MARK: - Alert
    func alert() {
        let alert = UIAlertController(title: "Some Fields\nAre Empty", message: "Please, fill all the fields", preferredStyle: UIAlertControllerStyle.alert)
        
        //MARK: - Temporary solution
        //Currently this is the only way to dismiss the PopUpViewController
        //Requires modification: add the cancel button on the view itself
        
        //discards and closes popUpView
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {[weak self] action in
            self?.closeVC()
            }
        ))
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
        self.present(alert, animated: true, completion: nil)
        
    }
}
















