//
//  Constants.swift
//  WorkoutCompanion
//
//  Created by WEI XIE on 2016-06-02.
//  Copyright © 2016 WEI.XIE. All rights reserved.
//

import Foundation
import UIKit

struct Constants{
    enum CoreDataEntityType: String{
        case ExerciseData
        case Exercise
    }
    //Theme colors
    static let themeColorBlack = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    static let themeColorLightSeaGreen = UIColor(red: 27/255, green: 154/255, blue: 170/255, alpha: 1.0)
    static let themeColorDarkImperialBlue = UIColor(red: 8/255 , green: 62/255, blue: 92/255, alpha: 1.0)
    static let themeColorWhite = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1.0)
    static let themeColorMadderLake = UIColor(red: 204/255, green: 41/255, blue: 54/255, alpha: 1.0)
    static let themeColorCultured = UIColor(red: 251/255, green: 245/255, blue: 243/255, alpha: 1.0)
    static let themeColorAlabuster = UIColor(red: 236/255, green: 235/255, blue: 228/255, alpha: 1.0)
    static let themeColorGreenSheen = UIColor(red: 100/255, green: 182/255, blue: 172/255, alpha: 1.0)
    static let themeColorHarvardCrimson = UIColor(red: 194/255, green: 1/255, blue: 20/255, alpha: 1.0)
    static let themeColorBackgroundGrey = UIColor(red:0.33, green:0.33, blue:0.33, alpha:1.0)
    
    //String constants
    static let stringListTableViewTitle = "Exercise"
    static let stringPlaceHolderName = "Name"
    static let stringWarningNameEmpty = "Name cannot be empty"
    static let stringWarningDataEmpty = "Data cannot be empty"
    
    static let stringButtonCancel = "Cancel"
    static let stringButtonAdd = "Add"
    static let stringButtonDone = "Done"
    
    
    static let stringAlertTitleAddExercise = "Add An Exercise"
    static let stringAlertSubtitleEnterName = "Enter the name"
    
    static let stringAlertTitleAddWorkout = "Add An Workout"
    static let stringAlertSubtitleEnterData = "Enter the data below"
    
    static let stringPlaceHolderReps = "Reps Per Set"
    static let stringPlaceHolderSets = "Total Sets"
    static let stringPlaceHolderWeight = "Weight Per Rep"
    
    
    
    
    
    
}
