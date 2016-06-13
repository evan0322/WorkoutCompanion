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
    @NSManaged var exerciseData: NSSet
}

class ExerciseData: NSManagedObject {
    @NSManaged var date: String
    @NSManaged var name: String
    @NSManaged var reps: String
    @NSManaged var sets: String
    @NSManaged var weights: String
    @NSManaged var exercise: Exercise
}