//
//  DataManager.swift
//  WorkoutCompanion
//
//  Created by WEI XIE on 2016-06-02.
//  Copyright © 2016 WEI.XIE. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    var exerciseDataTypes = ["Name","Weights","Sets","Reps","Date"]
    
    let appDelegate:AppDelegate
    let managedContext:NSManagedObjectContext
    
    init() {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
    }
    
    
    func saveExerciseData(dataDict: Dictionary<String, AnyObject>, exerciseName:String) -> Bool{
        guard let entity = NSEntityDescription.entityForName(Constants.CoreDataEntityType.ExerciseData.rawValue, inManagedObjectContext: managedContext) else {
            return false
        }
        let exerciseData = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as! ExerciseData
        for (key, data) in dataDict {
            exerciseData.setValue(data, forKey: key)
        }
        
        //Fetch exercise type and attach data to it.
        let fetchRequest = NSFetchRequest(entityName: Constants.CoreDataEntityType.Exercise.rawValue)
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            for exercise in results as! [Exercise]{
                guard let name = exercise.valueForKey("name") else {
                    return false
                }
                if name as! String == exerciseName {
                    exerciseData.exercise = exercise
                    
                    
                    let datas = exercise.mutableOrderedSetValueForKey("exerciseData")
                    datas.insertObject(exerciseData, atIndex: 0)
                    try managedContext.save()
                }
            }
            return true
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
    }
    
    func saveExercise(dataDict: Dictionary<String, String>) -> Bool{
        guard let entity = NSEntityDescription.entityForName(Constants.CoreDataEntityType.Exercise.rawValue, inManagedObjectContext: managedContext) else {
            return false
        }
        let managedObject = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext)
        for (key, data) in dataDict {
            managedObject.setValue(data, forKey: key)
        }
        do{
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    func getExercise (name:String) -> Exercise? {
        let fetchRequest = NSFetchRequest(entityName: Constants.CoreDataEntityType.Exercise.rawValue)
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! Array<Exercise>
            for  exercise in results {
                if exercise.name == name {
                    return exercise
                }
            }
            return nil
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func getExerciseList() -> Array<Exercise>? {
        let fetchRequest = NSFetchRequest(entityName: Constants.CoreDataEntityType.Exercise.rawValue)
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! Array<Exercise>
            
            return results
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return nil
        }
    }
//    
//    func saveExerciseData(dataDict: Dictionary<String, AnyObject>, exerciseObject:NSManagedObject) -> Bool{
//        guard let entity = NSEntityDescription.entityForName(Constants.CoreDataEntityType.ExerciseData.rawValue, inManagedObjectContext: managedContext) else {
//            return false
//        }
//        let managedObject = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext)
//        for (key, data) in dataDict {
//            managedObject.setValue(data, forKey: key)
//        }
//        var excerciseData = exerciseObject
//        do{
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Could not save \(error), \(error.userInfo)")
//            return false
//        }
//        return true
//    }
    
    
    
//    func savaEntity(dataDict: Dictionary<String, AnyObject>, entityType:Constants.CoreDataEntityType) -> Bool{
//        guard let entity = NSEntityDescription.entityForName(entityType.rawValue, inManagedObjectContext: managedContext) else {
//            return false
//        }
//        let managedObject = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext)
//        for (key, data) in dataDict {
//            managedObject.setValue(data, forKey: key)
//        }
//        do{
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Could not save \(error), \(error.userInfo)")
//            return false
//        }
//        return true
//    }
//    
//    
//    func savaEntity(dataDict: Dictionary<String, AnyObject>, entityType:Constants.CoreDataEntityType, parentEntityName:String, parentEntityType:Constants.CoreDataEntityType) -> Bool{
//        guard let entity = NSEntityDescription.entityForName(entityType.rawValue, inManagedObjectContext: managedContext) else {
//            return false
//        }
//        let managedObject = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext)
//        for (key, data) in dataDict {
//            managedObject.setValue(data, forKey: key)
//        }
//        
//        //Fetch parent entity
//        let fetchRequest = NSFetchRequest(entityName: dataType.rawValue)
//        do {
//            var dataArray = [Dictionary<String,String>]()
//            let results =
//                try managedContext.executeFetchRequest(fetchRequest)
//        }
//        
//        
//        for  parentEntityObject in parentEntityObjects as Array<Dictionary<String,String>> {
//            guard let name = parentEntityObject["name"] else {
//                print("Parent entity does not have a name parameter.")
//                return false
//            }
//            if name = parentEntityName
//        }
//        
//    }
//    
//    
//    
//    func saveData(dataDict: Dictionary<String, AnyObject>, dataType:Constants.CoreDataEntityType) ->Bool{
//        guard let entity = NSEntityDescription.entityForName(dataType.rawValue, inManagedObjectContext: managedContext) else {
//            return false
//        }
//        let managedObject = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext)
//        
//        for (key, data) in dataDict {
//            managedObject.setValue(data, forKey: key)
//        }
//        
//        do{
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Could not save \(error), \(error.userInfo)")
//            return false
//        }
//        return true
//    }
//    
//    func getData(dataType: Constants.CoreDataEntityType) -> Array<Dictionary<String,String>>?{
//        let fetchRequest = NSFetchRequest(entityName: dataType.rawValue)
//        do {
//            var dataArray = [Dictionary<String,String>]()
//            let results =
//            try managedContext.executeFetchRequest(fetchRequest)
//            for managedObject in results as! [NSManagedObject]{
//                var dataDictionary = [String:String]()
//                for exerciseDataType in exerciseDataTypes{
//                    guard let value = managedObject.valueForKey(exerciseDataType) else{
//                        return nil
//                    }
//                    dataDictionary[exerciseDataType] = value as? String
//                }
//                dataArray.append(dataDictionary)
//            }
//            return dataArray
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//            return nil
//        }
//    }
    
    func deleteAllData(dataType: Constants.CoreDataEntityType) -> Bool
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: dataType.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Detele all data in \(dataType.rawValue) error : \(error) \(error.userInfo)")
            return false
        }
    }

}
