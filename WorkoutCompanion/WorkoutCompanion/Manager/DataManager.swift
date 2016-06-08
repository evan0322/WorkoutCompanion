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
    
    func saveData(dataDict: Dictionary<String, AnyObject>, dataType:Constants.CoreDataType) ->Bool{
        guard let entity = NSEntityDescription.entityForName(dataType.rawValue, inManagedObjectContext: managedContext) else {
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
    
    func getData(dataType: Constants.CoreDataType) -> Array<Dictionary<String,String>>?{
        let fetchRequest = NSFetchRequest(entityName: dataType.rawValue)
        do {
            var dataArray = [Dictionary<String,String>]()
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results as! [NSManagedObject]{
                var dataDictionary = [String:String]()
                for exerciseDataType in exerciseDataTypes{
                    guard let value = managedObject.valueForKey(exerciseDataType) else{
                        return nil
                    }
                    dataDictionary[exerciseDataType] = value as! String
                }
                dataArray.append(dataDictionary)
            }
            return dataArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }

}
