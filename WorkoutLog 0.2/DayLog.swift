//
//  DayLog.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 922//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import Foundation
import CoreData

class DayLog: NSManagedObject {
    public func getExerciseArray() -> [ExerciseLog] {
        if let array = exercises?.allObjects as? [ExerciseLog] {
            return array
        }
        return [ExerciseLog]()
    }
    
    public func getMuscleArray() -> [MuscleLog] {
        if let array = muscles?.allObjects as? [MuscleLog] {
            return array
        }
        return [MuscleLog]()
    }
    
    class func formatDateToDays(date: Date) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let stringDate = date.toString(dateFormat: "dd/MM/yyyy")
        
        if let formattedDate = dateFormatter.date(from: stringDate) {
            return formattedDate
        } else {
            return date
        }
    }
    
    class func findOrCreateDayLog(matching date: Date, in context: NSManagedObjectContext) throws -> (DayLog, Bool) {
        let request: NSFetchRequest<DayLog> = DayLog.fetchRequest()
        request.predicate = NSPredicate(format: "date = %@", date as NSDate)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return (matches[0], true)
            }
        } catch {
            throw error
        }
        
        let dayLog = DayLog(context: context)
        dayLog.date = date // as NSDate
        dayLog.exercises = NSSet()
        dayLog.muscles = NSSet()
        
        if let days = try? context.count(for: DayLog.fetchRequest()) {
            dayLog.number = Int64(days)
        } else {
            dayLog.number = 1
        }
        
        return (dayLog, false)
    }
    
    //Updates the numeration of all day logs
    class func updateDayNumeration(in context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<DayLog> = DayLog.fetchRequest()
        let descriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [descriptor]
        do {
            let days = try context.fetch(request)
            var number: Int64 = 1
            for day in days {
                day.number = number
                number += 1
            }
            do {
                try context.save()
            } catch {
                print("Context could not be saved in class DayLog, method updateDayNumeration")
            }
        } catch {
            print("Request cannot be retrieved in class DayLog, method updateDayNumeration")
            throw error
        }
    }
    
    public func updateMuscles(in context: NSManagedObjectContext) {
        let exercises = self.getExerciseArray()
        var muscleNames = [String]()
        
        //first clear all muscles from dayLog
        if let set = self.muscles {
            self.removeFromMuscles(set)
        }

        for e in exercises {
//            print(e)
            if let exName = e.name {
                if let mArray = Database.exercises[exName] {
                    for m in mArray {
                        if !muscleNames.contains(m) {
                            muscleNames.append(m)
                        }
                    }
                }
            }
        }
        let muscleSet = NSSet()
        for m in muscleNames {
            let muscleLog = MuscleLog(context: context)
            muscleLog.day = self
            muscleLog.name = m
            muscleSet.adding(muscleLog)
        }
        self.addToMuscles(muscleSet)
        try? context.save()
    }
}