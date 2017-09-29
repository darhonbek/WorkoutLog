//
//  DayTableViewCell.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 916//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var dayLog: DayLog? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        let date = dayLog?.date as! Date
        dateLabel.text = date.toString(dateFormat: "dd/MM/yyyy")
        let numberLabelText = "Day " + String(Int((dayLog?.number)!))
        numberLabel.text = numberLabelText
    }
}
