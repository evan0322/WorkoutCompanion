//
//  FirstViewController.swift
//  WorkoutCompanion
//
//  Created by WEI XIE on 2016-05-30.
//  Copyright © 2016 WEI.XIE. All rights reserved.
//

import UIKit
import CoreData
import ScrollableGraphView

class ExerciseListTableVIewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    var fetchedResultsController: NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController!.navigationBar.tintColor = Constants.themeColorHarvardCrimson
        self.navigationController?.navigationBar.barTintColor = Constants.themeColorAlabuster
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : Constants.themeColorHarvardCrimson
        ]
        self.tableView.backgroundColor = Constants.themeColorAlabuster
        self.title = "Exercise"
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        
        
        self.tabBarController?.tabBar.tintColor = UIColor.blackColor()
        self.tabBarController?.tabBar.barTintColor = Constants.themeColorAlabuster
        
        //Fetch exercise types
        let fetchRequest = NSFetchRequest(entityName: Constants.CoreDataEntityType.Exercise.rawValue)
        let fetchSort = NSSortDescriptor(key:"name", ascending: true)
        fetchRequest.sortDescriptors = [fetchSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unable to perform fetch: \(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sectionCount = fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionCount
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionData.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let exercise = fetchedResultsController.objectAtIndexPath(indexPath) as! Exercise
        
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as! CardTableViewCell
        cell.cardTitleLabel!.text = exercise.name
        cell.backgroundColor = UIColor.clearColor()
        cell.cardDateLabel?.textColor = UIColor.lightGrayColor()
        
        
        if let exerciseDetails = exercise.exerciseData.allObjects as? [ExerciseData] {
            if exerciseDetails.count < 1 {
                return cell
            }
            let data: [Double] = exerciseDetails.map{ exerciseDetail in
                return Double(exerciseDetail.reps*exerciseDetail.sets*exerciseDetail.weight)
            }
            let labels: [String] = exerciseDetails.map{ exerciseDetail in
                return exerciseDetail.date.toString()
            }
            cell.cardGraphView!.setData(data, withLabels: labels)
            cell.cardGraphView!.rangeMax = data.maxElement()!
            
        } else {
        
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        let addExerciseController = UIAlertController(title: "Add an exercise", message: "Enter the name", preferredStyle: .Alert)
        addExerciseController.view.tintColor = Constants.themeColorBlack
        addExerciseController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "name"
            textField.clearButtonMode = .WhileEditing;
        }
        let confirmAction = UIAlertAction(title: "Ok", style: .Default) { (alertAction) in
            let entity = NSEntityDescription.entityForName(Constants.CoreDataEntityType.Exercise.rawValue, inManagedObjectContext: self.context)
            let exercise = Exercise(entity: entity!, insertIntoManagedObjectContext:self.context)
            let textField = addExerciseController.textFields!.first
            guard let name = textField?.text else {
                return
            }
            exercise.name = name
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Error saving movie \(error.localizedDescription)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction) in
            print("cancel pressed")
        }
        
        addExerciseController.addAction(cancelAction)
        addExerciseController.addAction(confirmAction)
        presentViewController(addExerciseController, animated:true, completion:nil)
    }
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        //TODO
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        default: break
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let exercise = fetchedResultsController.objectAtIndexPath(indexPath) as! Exercise
            context.deleteObject(exercise)
            do {
                try context.save()
            } catch let error as NSError {
                print("Error saving context after delete: \(error.localizedDescription)")
            }
        default:break
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        //Disable swap to delete function as it will confuse the user with the graph view
        if self.tableView.editing {return .Delete}
        return .None
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toDetailSegue") {
            if let detailTableViewController = segue.destinationViewController as? ExerciseDetailTableViewController{
                let indexPath = self.tableView.indexPathForSelectedRow!
                let exercise = fetchedResultsController.objectAtIndexPath(indexPath) as! Exercise
                detailTableViewController.exercise = exercise
            }
            // pass data to next view
        }
    }
}


