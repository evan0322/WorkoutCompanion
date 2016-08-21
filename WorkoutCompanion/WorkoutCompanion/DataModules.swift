//
//  DataModules.swift
//  WorkoutCompanion
//
//  Created by Wei Xie on 2016-06-10.
//  Copyright © 2016 WEI.XIE. All rights reserved.
//

import Foundation

import CoreData
import Foundation

class Exercise: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var createDate: NSDate
    @NSManaged var exerciseData: NSSet
}

class ExerciseData: NSManagedObject {
    @NSManaged var date: NSDate
    @NSManaged var name: String
    @NSManaged var reps: Int64
    @NSManaged var sets: Int64
    @NSManaged var weight: Int64
    @NSManaged var exercise: Exercise
}