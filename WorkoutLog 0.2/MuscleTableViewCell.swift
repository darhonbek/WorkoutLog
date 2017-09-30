//
//  MuscleTableViewCell.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 929//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import UIKit

class MuscleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var muscleNameLabel: UILabel!
    
    var muscleName: String? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let muscle = muscleName {
            muscleNameLabel.text = muscle
        }
    }

}
