//
//  Date.swift
//  WorkoutLog 0.2
//
//  Created by Darkhonbek Mamataliev on 922//17.
//  Copyright © 2017 Darkhonbek Mamataliev. All rights reserved.
//

import Foundation

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
