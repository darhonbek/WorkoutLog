//
//  DayTableViewController.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 9/14/17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import CoreData
import UIKit
import Foundation

class DayTableViewController: UITableViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    public var container: NSPersistentContainer?
    public var selectedRowLog: SetLog?
    public var dayLog: DayLog? {
        didSet {
            updateUI()
            updateExerciseArray()
        }
    }
    private var exercises: [ExerciseLog] = [ExerciseLog]()
    
    private func updateUI() {
        if let title = dayLog?.number {
            navItem.title = String(title)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableData), name: NSNotification.Name(rawValue: "loadExercises"), object: nil)
    }
    
    @objc private func updateTableData() {
        //MARK: Optimize
        //Very heavy fn call
        loadDayLog()
        updateExerciseArray()
        tableView.reloadData()
    }
    
    private func updateExerciseArray() {
        if let array = dayLog?.getExerciseArray() {
            exercises = ExerciseLog.sortExercises(array)
        }
    }
    
    private func loadDayLog() {
        if let unwrappedDayLog = self.dayLog,
            let context = container?.viewContext {
            if let updatedDayLog = try? ExerciseLog.reloadDayLog(unwrappedDayLog, in: context) {
                self.dayLog = updatedDayLog
            }
        }
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "Adding new exercise log" {
                if let vc = segue.destination as? AddLogPopUpViewController {
                    vc.dayLog = dayLog
                }
            } else if identifier == "Muscle List" {
                if let vc = segue.destination as? MusclesTableViewController {
                    vc.dayLog = dayLog
                }
            } else if identifier == "Edit log record" {
                if let vc = segue.destination as? EditLogViewController {
                    vc.setLog = selectedRowLog
                    vc.context = container?.viewContext
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return exercises.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < exercises.count {
            let sets = exercises[section].getSortedSetArray()
            return sets.count
        }
        return 0
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < exercises.count {
            return exercises[section].name
        }
        print("Error in DayTableViewController")
        return "Error, see log for details"
        
    }
    
    //Configures header section (alignment, etc.)
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textAlignment = NSTextAlignment.center
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setLog", for: indexPath)
        let exerciseLog = exercises[indexPath.section]
        let setLog = exerciseLog.getSortedSetArray()[indexPath.row]

        if let setCell = cell as? SetTableViewCell {
            setCell.setLog = setLog
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let setCell = cell as? SetTableViewCell {
            selectedRowLog = setCell.setLog
            let identifier = "Edit log record"
            performSegue(withIdentifier: identifier, sender: setCell)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let deleteCell = tableView.cellForRow(at: indexPath) as? SetTableViewCell {
                if let setLogToDelete = deleteCell.setLog {
                    
                    var flag = false
                    container?.viewContext.delete(setLogToDelete)
                    exercises[indexPath.section].removeFromSets(setLogToDelete)
                    if let temp = exercises[indexPath.section].sets?.count {
                        if temp == 0 {
                            flag = true
                            container?.viewContext.delete(
                                exercises[indexPath.section]
                            )
                            dayLog?.removeFromExercises(exercises[indexPath.section])
                            exercises.remove(at: indexPath.section)
                        }
                    }
                    try? container?.viewContext.save()
                    
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .left)
                    if flag {
                        var indexSet = IndexSet()
                        indexSet.insert(indexPath.section)
                        tableView.deleteSections(indexSet, with: .left)
                    }
                    tableView.endUpdates()
                    
                    //MARK: - modify to sort logs after deletion
                    updateTableData()
                }
            }
        }
    }
    
}









