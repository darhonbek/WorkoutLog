//
//  addDayPopUpViewController.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 913//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddDayPopUpViewController: UIViewController {
    
    public var date: Date = Date()
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    
    public static var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closePopUpWhenTappedAround()
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        date = datePicker.date
    }
    
    @IBAction func closePopUp(_ sender: UIButton) {
        date = DayLog.formatDateToDays(date: datePicker.date)
        let context = AppDelegate.viewContext
        do {
            let (temp, dayAlreadyExist) = try DayLog.findOrCreateDayLog(matching: date, in: context)
            AddDayPopUpViewController.date = temp.date
            if dayAlreadyExist {
                alert()
//                Day exists, proceed to day info
            }
            
            try context.save()
            //updates day enumeration
            
            try? DayLog.updateDayNumeration(in: context)
            //reloads data in HistoryTableViewControllwer
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadDays"), object: nil)
        }
        catch {
            print (error)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension AddDayPopUpViewController {
    private func presentViewController(alert: UIAlertController, animated flag: Bool, completion: (() -> Void)?) -> Void {
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: flag, completion: completion)
    }
    
    //MARK: - Alert
    func alert() {
        let alert = UIAlertController(title: "Date Already exists", message: "You will be proceeded to that day", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertActionStyle.default,
                                      handler: {
                                        (alert: UIAlertAction!) in
                                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Day exists, proceed to day info"), object: nil)
                                        }))
        
        presentViewController(alert: alert, animated: true, completion: nil)
    }
}
