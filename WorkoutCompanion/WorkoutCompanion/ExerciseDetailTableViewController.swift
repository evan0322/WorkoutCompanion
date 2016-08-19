//
//  ExerciseDataTableViewController.swift
//  WorkoutCompanion
//
//  Created by Wei Xie on 2016-06-13.
//  Copyright © 2016 WEI.XIE. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView

class ExerciseDetailTableViewController: UITableViewController {
    
    var exercise:Exercise!
    var exerciseDetails:[ExerciseData]?
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseDetails = exercise.exerciseData.allObjects as? [ExerciseData]
        exerciseDetails = exerciseDetails!.sort(){ data1,data2 in
            return data1.date.compare(data2.date) == NSComparisonResult.OrderedDescending
        }
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = Constants.themeColorAlabuster
        self.title = exercise.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let details = exerciseDetails else {
            return 0
        }
        return details.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CardTableViewCell = tableView.dequeueReusableCellWithIdentifier("cardTableViewCell", forIndexPath: indexPath) as! CardTableViewCell
        guard let details = exerciseDetails else {
            return cell
        }
        //        cell.textLabel!.text = detail.date
        let detail = details[indexPath.row] as ExerciseData
        cell.cardFirstSectionLabel!.text = "\(String(detail.sets))"
        cell.cardSecondSectionLabel!.text = "\(String(detail.reps))"
        cell.cardThirdSectionLabel!.text = "\(String(detail.weight))"
        cell.cardDateLabel!.text = detail.date.toString()
        cell.cardDetailLabel!.text = "\(Int(detail.sets)*Int(detail.reps)*Int(detail.weight))"
        cell.backgroundColor = UIColor.clearColor()
        cell.tintColor = Constants.themeColorWhite
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let exerciseDetail = exerciseDetails![indexPath.row]
            context.deleteObject(exerciseDetail)
            exerciseDetails?.removeAtIndex(indexPath.row)
            do {
                try context.save()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            } catch let error as NSError {
                print("Error saving context after delete: \(error.localizedDescription)")
            }
        default:break
        }
    }
    
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            contentViewColor:Constants.themeColorAlabuster,
            showCircularIcon: false,
            shouldAutoDismiss: false,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        let repsInput = alert.addTextField("Reps")
        let setsInput = alert.addTextField("Sets")
        let weightInput = alert.addTextField("Weight Per Set")
        repsInput.keyboardType = UIKeyboardType.NumberPad
        setsInput.keyboardType = UIKeyboardType.NumberPad
        weightInput.keyboardType = UIKeyboardType.NumberPad
        
        
        var alertViewResponder = SCLAlertViewResponder(alertview: alert)
        
        alert.addButton("Add", backgroundColor: Constants.themeColorBlack, textColor: UIColor.whiteColor(), showDurationStatus: false) {
           //Validate data
            guard (repsInput.text != "" && setsInput.text != "" && weightInput.text != "") else{
                alertViewResponder.setSubTitle("Data cannot be empty")
                return
            }
            guard let entity = NSEntityDescription.entityForName(Constants.CoreDataEntityType.ExerciseData.rawValue, inManagedObjectContext:self.context) else {
                return
            }
            let exerciseData = ExerciseData(entity: entity, insertIntoManagedObjectContext:self.context)
            exerciseData.setValue(Int(repsInput.text!), forKey: "Reps")
            exerciseData.setValue(Int(setsInput.text!), forKey: "Sets")
            exerciseData.setValue(Int(weightInput.text!), forKey: "Weight")
            exerciseData.setValue(NSDate(), forKey: "Date")
            exerciseData.exercise = self.exercise
            let exerciseDatas = self.exercise.mutableOrderedSetValueForKey("exerciseData")
            exerciseDatas.insertObject(exerciseData, atIndex: 0)
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Error saving movie \(error.localizedDescription)")
            }
            alert.hideView()
            self.exerciseDetails?.insert(exerciseData, atIndex: 0)
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Fade)
            self.tableView.endUpdates()
            
        }
        
        alert.addButton("Cancel", backgroundColor: Constants.themeColorMadderLake, textColor: UIColor.whiteColor(), showDurationStatus: false) {
            alert.hideView()
        }
        
        alertViewResponder = alert.showTitle(
            "Add An Workout", // Title of view
            subTitle: "Enter the data below", // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Done", // Optional button value, default: ""
            style: .Success, // Styles - see below.
            colorStyle: 0xFFFFFF,
            colorTextButton: 0xFFFFFF
        )
    }
}