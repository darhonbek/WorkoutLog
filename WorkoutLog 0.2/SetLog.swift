//
//  Set.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 916//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import Foundation
import CoreData

class SetLog: NSManagedObject {
    //Updates the numeration of all day logs
    class func updateSetNumeration(in context: NSManagedObjectContext, for exercise: ExerciseLog) throws {
        let request: NSFetchRequest<SetLog> = SetLog.fetchRequest()
        let descriptor = NSSortDescriptor(key: "number", ascending: true)
        
        //MARK: - Suspicious line of code. Might now work
        request.predicate = NSPredicate(format: "exercise = %@", exercise)
        request.sortDescriptors = [descriptor]
        do {
            let sets = try context.fetch(request)
            var number: Int32 = 1
            for set in sets {
                set.number = number
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
}
