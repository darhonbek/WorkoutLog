//
//  ExerciseTableViewCell.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 923//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import UIKit

class SetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var setInfoLabel: UILabel!
    @IBOutlet weak var setNumberLabel: UILabel!
    
    public var setNumber: Int32? {
        didSet {
            updateUI()
        }
    }
    public var setLog: SetLog? {
        didSet {
            setNumber = setLog?.number
            updateUI()
        }
    }
    
    private func updateUI() {
        //MARK: incompleted
        var str1 = "#"
        str1.append(setNumber?.description ?? "x")
        str1.append(": ")
        setNumberLabel.text = str1
        
        if let setLog = setLog {
            var str = String()
            var repsStr = setLog.reps.description
            repsStr.append(" reps x ")
            var weightStr = setLog.weight.description
            weightStr.append(" kg")
            str.append(repsStr)
            str.append(weightStr)
            setInfoLabel.text = str
        } else {
            setInfoLabel.text = " reps x weight"
        }
    }
}
