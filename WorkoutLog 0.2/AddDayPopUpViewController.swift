//
//  addDayPopUpViewController.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 913//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import UIKit
import CoreData

class AddDayPopUpViewController: UIViewController {
    
    public var date: Date = Date()
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closePopUpWhenTappedAround()
        doneButton.addBorder(side: .Top, color: .lightGray, width: 1.0)
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        date = datePicker.date
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePopUp(_ sender: UIButton) {
        date = DayLog.formatDateToDays(date: datePicker.date)
        let context = AppDelegate.viewContext
        do {
            let _ = try? DayLog.findOrCreateDayLog(matching: date, in: context)
            try context.save()
            //reload data in HistoryTableViewControllwer
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadDays"), object: nil)
        }
        catch {
            print (error)
        }
        dismiss(animated: true, completion: nil)
    }
}
