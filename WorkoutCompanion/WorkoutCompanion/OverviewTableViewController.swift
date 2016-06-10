//
//  FirstViewController.swift
//  WorkoutCompanion
//
//  Created by WEI XIE on 2016-05-30.
//  Copyright © 2016 WEI.XIE. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {
    
    var exercises = [Exercise]()
    let manager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let retrievedExercises = manager.getExerciseList() else {
            return
        }
        exercises = retrievedExercises
        //manager.getData(Constants.CoreDataType.Exercise)
        
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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
        cell.textLabel!.text = exercises[indexPath.row].name
        return cell
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        let addController = UIAlertController(title: "Add an exercise", message: "Enter the name", preferredStyle: .Alert)
        addController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "name"
            textField.clearButtonMode = .WhileEditing;
        }
        let confirmAction = UIAlertAction(title: "Ok", style: .Default) { (alertAction) in
            print("confirm pressed")
            let textFeild = addController.textFields![0] as UITextField
            guard let text = textFeild.text else{
                return
            }
            guard self.manager.saveExercise(["name":text]) else {
                print("cannot store exercise")
                return
            }
            guard let retrievedExercises = self.manager.getExerciseList() else {
                return
            }
            self.exercises = retrievedExercises
            print(self.exercises)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction) in
            print("cancel pressed")
        }
        addController.addAction(cancelAction)
        addController.addAction(confirmAction)
        presentViewController(addController, animated: true) {
            
        }
    }
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        manager.deleteAllData(.Exercise)
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

