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
import SCLAlertView

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
        self.tableView.separatorStyle = .None
        
        self.title = Constants.stringListTableViewTitle
        
        navigationItem.leftBarButtonItem = editButtonItem()
        

        
        //Fetch exercise types
        let fetchRequest = NSFetchRequest(entityName: Constants.CoreDataEntityType.Exercise.rawValue)
        let fetchSort = NSSortDescriptor(key:"createDate", ascending: false)
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
        if sectionData.numberOfObjects < 1 {
            UIManager.sharedInstance().handleNoDataLabel(true, forTableView: self.tableView)
            self.navigationItem.leftBarButtonItem = nil
        } else {
            UIManager.sharedInstance().handleNoDataLabel(false, forTableView: self.tableView)
            self.navigationItem.leftBarButtonItem = editButtonItem()
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
                for view in cell.cardGraphView!.subviews{
                    view.removeFromSuperview()
                }
                return cell
            }
            
            let data: [Double] = exerciseDetails.map{ exerciseDetail in
                return Double((Double(exerciseDetail.reps)/30+1)*Double(exerciseDetail.weight))
            }
            let labels: [String] = exerciseDetails.map{ exerciseDetail in
                return exerciseDetail.date.toString()
            }
            
            //Generate ScrollableGraphView
            //Make sure the graph view will not exceed content view while editing
            let graphView = UIManager.sharedInstance().generateScrollableGraphViewViewWithFrame(CGRectMake(0, 0, cell.contentView.frame.width - 55, cell.cardGraphView!.frame.height), data: data, labels: labels)
            for view in cell.cardGraphView!.subviews{
                view.removeFromSuperview()
            }
            cell.cardGraphView!.addSubview(graphView)
            
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
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
        let nameInput = alert.addTextField(Constants.stringPlaceHolderName)
        
        var alertViewResponder = SCLAlertViewResponder(alertview: alert)
        
        alert.addButton(Constants.stringButtonAdd, backgroundColor: Constants.themeColorBlack, textColor: UIColor.whiteColor(), showDurationStatus: false) {
            //Validate data
            guard (nameInput.text != "") else{
                alertViewResponder.setSubTitle(Constants.stringWarningNameEmpty)
                return
            }
            
            let entity = NSEntityDescription.entityForName(Constants.CoreDataEntityType.Exercise.rawValue, inManagedObjectContext: self.context)
            let exercise = Exercise(entity: entity!, insertIntoManagedObjectContext:self.context)
            guard let name = nameInput.text else {
                return
            }
            exercise.name = name
            exercise.createDate = NSDate()
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Error saving movie \(error.localizedDescription)")
            }
            alert.hideView()
        }
        
        alert.addButton(Constants.stringButtonCancel, backgroundColor: Constants.themeColorMadderLake, textColor: UIColor.whiteColor(), showDurationStatus: false) {
            alert.hideView()
        }
        
        alertViewResponder = alert.showTitle(
            Constants.stringAlertTitleAddExercise, // Title of view
            subTitle: Constants.stringAlertSubtitleEnterName, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: Constants.stringButtonDone, // Optional button value, default: ""
            style: .Success, // Styles - see below.
            colorStyle: 0xFFFFFF,
            colorTextButton: 0xFFFFFF
        )
        
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
            self.navigationController?.setEditing(false, animated: true)
            self.tableView!.setEditing(false, animated: true)
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
    
    // MARK: - Utility functions
    
}


