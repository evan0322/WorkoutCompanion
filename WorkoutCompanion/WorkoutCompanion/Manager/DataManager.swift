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
            //Error here
            let trimedKey = key.stringByReplacingOccurrencesOfString(":", withString: "")
            managedObject.setValue(data, forKey: trimedKey)
        }
        
        do{
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    func getData(dataType: Constants.CoreDataType) -> Array<Dictionary<String,String>>{
        let fetchRequest = NSFetchRequest(entityName: dataType.rawValue)
        var dataArray = [Dictionary<String,String>]()
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            let managedObjects = results as! [NSManagedObject]

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        var testDict = ["1":"1"]
        dataArray.append(testDict)
        return dataArray
    }

}
