//
//  GraphviewViewController.swift
//  WorkoutCompanion
//
//  Created by WEI XIE on 2016-05-30.
//  Copyright © 2016 WEI.XIE. All rights reserved.
//

import UIKit
import CoreData

class AddExerciseDetailTableViewController: UITableViewController {
    
    var exercise:Exercise!
    
    var exerciseDataTypes = ["Name","Weights","Sets","Reps","Date"]
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inputCell", forIndexPath: indexPath)
        guard let textLabel = cell.contentView.viewWithTag(100) as? UILabel else {
            print("error, cannot get element from table view cell")
            return cell
        }
        var labelTexts = exerciseDataTypes.map{(dataType) -> String in
            let newStr:String = dataType + String(":")
            return newStr
        }
        textLabel.text = labelTexts[indexPath.row]
        return cell
    }
    
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        let totalDataTypes = exerciseDataTypes.count
        guard let entity = NSEntityDescription.entityForName(Constants.CoreDataEntityType.ExerciseData.rawValue, inManagedObjectContext:context) else {
            return
        }
        let exerciseDetail = ExerciseData(entity: entity, insertIntoManagedObjectContext:self.context)
        
        for i in 0...totalDataTypes-1{
            let indexPath = NSIndexPath(forRow:i, inSection:0)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            guard let textLabel = cell!.contentView.viewWithTag(101) as? UITextField else {
                print("error, cannot get element from table view cell")
                return
            }
            guard let textLabelData = textLabel.text where textLabel.text != "" else {
                print("error, input field is empty")
                let alert = UIAlertController(title: "Error", message: "Input cannot be empty", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
                })
                let confirmAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) -> Void in
                })
                alert.addAction(cancelAction)
                alert.addAction(confirmAction)
                presentViewController(alert, animated: true, completion:nil)
                return
            }
            exerciseDetail.setValue(textLabelData, forKey: exerciseDataTypes[i])
        }
        exerciseDetail.exercise = exercise
        let exerciseDetails = exercise.mutableOrderedSetValueForKey("exerciseData")
        exerciseDetails.insertObject(exerciseDetail, atIndex: 0)
        do {
            try self.context.save()
            self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
        } catch let error as NSError {
            print("Error saving movie \(error.localizedDescription)")
        }
}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
