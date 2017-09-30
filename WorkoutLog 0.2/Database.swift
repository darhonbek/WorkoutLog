//
//  Database.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 929//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import Foundation
import CoreData

class Database {
    
    static var muscles = [String: [String]]()
    static var exercises = [String: [String]]()
    
    static func loadData() {
        muscles = [
            "Abdominals (press)": ["Bent Knee Hip Raise", "Cross Body Crunch", "Crunches", "Decline Crunch", "Leg Raise", "Seated Ab Crunch", "Side Bend", "Side Plank"],
            "Arms":         ["Alternate Hammer Curl", "Biceps Curl Barbell", "Biceps Curl Dumbbell", "Biceps Curl with Deadlift", "Concentration Curl", "Overhead Curl", "Rope Hammer Curl"],
            "Back":         ["Back Flyes With Resistance bands", "Hyperextensions", "Lat Pulldown", "Rear Deltoid Row", "Reverse Grip Bent-Over Rows", "Seated Cable Rows", "T-Bar Row", "V-Bar Pulldown"],
            "Chest":        ["Barbell Incline Bench Press", "Bench Press", "Butterfly", "Cable Crossover", "Decline Dumbbell Bench Press", "Dumbbell Bench Press", "Dumbbell Incline Bench Press", "Dummbbell Pullover", "Incline Dumbbell Flyes", "Smith Machine Bench Press"],
            "Shoulders":    ["Arnold Dumbbell Press", "Barbell Upright Row", "Bent Over Low-Pulley Side Lateral", "Bent Over Rear Delt Row With Head On Bench", "Cable Seated Rear Lateral Raise", "Dumbbell Shoulder Press", "Front Cable Raise", "Machine Shoulder (Military) Press", "Seated Barbell Military Press", "Side Lateral Raise"],
            "Legs":         ["Barbell Lunge", "Barbell Squat", "Butt Fit (Bridge)", "Leg Press", "One-Legged Cable Kickback", "Romanian Deadlift", "Seated Calf Raise", "Seated Leg Curl", "Standing Leg Curl", "Thigh Abductor", "Thigh Adductor"]
        ]
        for (muscle, exeriseArray) in muscles {
            for exercise in exeriseArray {
                exercises[exercise]?.append(muscle)
            }
        }
    }
}
