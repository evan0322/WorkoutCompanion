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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barStyle = UIBarStyle.default
        self.navigationController!.navigationBar.tintColor = Constants.themeColorHarvardCrimson
        self.navigationController?.navigationBar.barTintColor = Constants.themeColorAlabuster
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : Constants.themeColorHarvardCrimson
        ]
        self.tableView.backgroundColor = Constants.themeColorAlabuster
        self.tableView.separatorStyle = .none
        
        self.title = Constants.stringListTableViewTitle
        
        navigationItem.leftBarButtonItem = editButtonItem
        

        
        //Fetch exercise types
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.CoreDataEntityType.Exercise.rawValue)
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionCount = fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return 0
        }
        if sectionData.numberOfObjects < 1 {
            UIManager.sharedInstance().handleNoDataLabel(add: true, forTableView: self.tableView)
            self.navigationItem.leftBarButtonItem = nil
        } else {
            UIManager.sharedInstance().handleNoDataLabel(add: false, forTableView: self.tableView)
            self.navigationItem.leftBarButtonItem = editButtonItem
        }
        return sectionData.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let exercise = fetchedResultsController.object(at: indexPath as IndexPath) as! Exercise
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath as IndexPath) as! CardTableViewCell
        cell.cardTitleLabel!.text = exercise.name
        cell.backgroundColor = UIColor.clear
        cell.cardDateLabel?.textColor = UIColor.lightGray
        
        
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
            let graphView = UIManager.sharedInstance().generateScrollableGraphViewViewWithFrame(data: data, labels: labels)
            for view in cell.cardGraphView!.subviews{
                view.removeFromSuperview()
            }
            cell.cardGraphView!.addSubview(graphView)
            
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 200
    }

    
    @IBAction func addButtonPressed(sender: AnyObject) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false, showCircularIcon: false, shouldAutoDismiss: false, contentViewColor:Constants.themeColorAlabuster
        )
        let alert = SCLAlertView(appearance: appearance)
        let nameInput = alert.addTextField(Constants.stringPlaceHolderName)
        
        var alertViewResponder = SCLAlertViewResponder(alertview: alert)
        
        alert.addButton(Constants.stringButtonAdd, backgroundColor: Constants.themeColorBlack, textColor: UIColor.white, showTimeout: nil) {
            //Validate data
            guard (nameInput.text != "") else{
                alertViewResponder.setSubTitle(Constants.stringWarningNameEmpty)
                return
            }
            
            let entity = NSEntityDescription.entity(forEntityName: Constants.CoreDataEntityType.Exercise.rawValue, in: self.context)
            let exercise = Exercise(entity: entity!, insertInto:self.context)
            guard let name = nameInput.text else {
                return
            }
            exercise.name = name
            exercise.createDate = Date()
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Error saving movie \(error.localizedDescription)")
            }
            alert.hideView()
        }
        
        alert.addButton(Constants.stringButtonCancel, backgroundColor: Constants.themeColorMadderLake, textColor: UIColor.white, showTimeout: nil) {
            alert.hideView()
        }
        
        alertViewResponder = alert.showTitle(Constants.stringAlertTitleAddExercise,
                                             subTitle: Constants.stringAlertSubtitleEnterName,
                                             timeout: nil,
                                             completeText: Constants.stringButtonDone,
                                             style: .success,
                                             colorStyle: 0xFFFFFF,
                                             colorTextButton: 0xFFFFFF,
                                             circleIconImage: nil,
                                             animationStyle: .topToBottom)
        
        
    }
    
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        //TODO
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default: break
        }
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath! as IndexPath], with: .automatic)
            self.navigationController?.setEditing(false, animated: true)
            self.tableView!.setEditing(false, animated: true)
        case .delete:
            tableView.deleteRows(at: [indexPath! as IndexPath], with: .automatic)
        default: break
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let exercise = fetchedResultsController.object(at: indexPath as IndexPath) as! Exercise
            context.delete(exercise)
            do {
                try context.save()
            } catch let error as NSError {
                print("Error saving context after delete: \(error.localizedDescription)")
            }
        default:break
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        //Disable swap to delete function as it will confuse the user with the graph view
        if self.tableView.isEditing {return .delete}
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetailSegue") {
            if let detailTableViewController = segue.destination as? ExerciseDetailTableViewController{
                let indexPath = self.tableView.indexPathForSelectedRow!
                let exercise = fetchedResultsController.object(at: indexPath) as! Exercise
                detailTableViewController.exercise = exercise
            }
            // pass data to next view
        }
    }
    
    // MARK: - Utility functions
    
}


