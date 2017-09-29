//
//  ExerciseLog.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 916//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import Foundation
import CoreData

class ExerciseLog: NSManagedObject {
    public func getSortedSetArray() -> [SetLog]{
        if var array = sets?.allObjects as? [SetLog] {
            for i in 1..<array.count {
                for j in 0 ..< i {
                    if array[i].number > array[j].number {
                        swap(&array[i], &array[j])
                    }
                }
            }
            return array
        }
        return [SetLog]()
    }
    
    class func modifyOrCreateExerciseLog(named name: String, reps: Int32, weight: Int32, dayLog: DayLog , in context: NSManagedObjectContext) throws -> ExerciseLog {
        let exercises = dayLog.getExerciseArray()
        for exercise in exercises {
            if exercise.name! == name {
                let setLog = SetLog(context: context)
                let numberOfSets = exercise.sets?.count ?? 0
                setLog.number = Int32(numberOfSets + 1)
                print(setLog.number)
                setLog.reps = reps
                setLog.weight = weight
                setLog.exercise = exercise
                exercise.addToSets(setLog)
                try context.save()
                return exercise
            }
        }
        let exercise = ExerciseLog(context: context)
        let setLog = SetLog(context: context)
        setLog.number = 1
        setLog.reps = reps
        setLog.weight = weight
        setLog.exercise = exercise
        exercise.name = name
        exercise.day = dayLog
        exercise.addToSets(setLog)
        dayLog.addToExercises(exercise)
        try context.save()
        return exercise
    }
    
    class func reloadDayLog(_ dayLog: DayLog, in context: NSManagedObjectContext) throws -> DayLog? {
        
        let request: NSFetchRequest<DayLog> = DayLog.fetchRequest()
        if let date = dayLog.date {
            request.predicate = NSPredicate(format: "date = %@", date)
            do {
                let matches = try context.fetch(request)
                if matches.count > 0 {
                    assert(matches.count == 1, "Database inconsistency. Class ExerciseLog, func reloadDayLog")
                    return matches[0]
                }
            } catch {
                throw error
            }
        }
        return nil
        
    }
}
