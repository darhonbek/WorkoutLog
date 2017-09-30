//
//  MuscleLog.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 929//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import Foundation
import CoreData

class MuscleLog: NSManagedObject {
    
    class func findOrCreateMuscleLog(dayLog: DayLog, named muscleName: String, in context: NSManagedObjectContext) throws -> MuscleLog {
        
        let request: NSFetchRequest<MuscleLog> = MuscleLog.fetchRequest()
        request.predicate = NSPredicate(format: "day = %@ AND  name = %@", dayLog, muscleName)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let muscleLog = MuscleLog(context: context)
        muscleLog.day = dayLog
        muscleLog.name = muscleName
        
        return muscleLog
    }

}
