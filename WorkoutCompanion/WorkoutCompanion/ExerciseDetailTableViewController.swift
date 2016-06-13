//
//  ExerciseDataTableViewController.swift
//  WorkoutCompanion
//
//  Created by Wei Xie on 2016-06-13.
//  Copyright © 2016 WEI.XIE. All rights reserved.
//

import UIKit

class ExerciseDetailTableViewController: UITableViewController {
    
    var exercise:Exercise!
    var exerciseDetails:[ExerciseData]?

    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseDetails = exercise.exerciseData.allObjects as? [ExerciseData]
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
        let cell = tableView.dequeueReusableCellWithIdentifier("detailListCell", forIndexPath: indexPath)
        guard let details = exerciseDetails else {
            return cell
        }
        let detail = details[indexPath.row] as ExerciseData
        cell.textLabel!.text = detail.date
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "addDetailSegue") {
            let nav = segue.destinationViewController as! UINavigationController
            let addExerciseDetailTableViewController =  nav.topViewController as! AddExerciseDetailTableViewController
            addExerciseDetailTableViewController.exercise = exercise
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
