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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseDetails = exercise.exerciseData.allObjects as? [ExerciseData]
        exerciseDetails = exerciseDetails!.sorted(by:{ data1,data2 in
            return data1.date.compare(data2.date as Date) == ComparisonResult.orderedDescending
        })
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = Constants.themeColorAlabuster
        self.title = exercise.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let details = exerciseDetails else {
            return 0
        }
        if details.count < 1 {
            UIManager.sharedInstance().handleNoDataLabel(add: true, forTableView: self.tableView)
        } else {
            UIManager.sharedInstance().handleNoDataLabel(add: false, forTableView: self.tableView)
        }
        return details.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell : CardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cardTableViewCell", for: indexPath as IndexPath) as! CardTableViewCell
        guard let details = exerciseDetails else {
            return cell
        }
        //Caculate One-Rep Max with Epley Formula
        let detail = details[indexPath.row] as ExerciseData
        let oneRepMax = detail.reps==1 ? Int(detail.weight) : Int((Double(detail.reps)/30+1)*Double(detail.weight))
        
        cell.cardFirstSectionLabel!.text = "\(String(detail.sets))"
        cell.cardSecondSectionLabel!.text = "\(String(detail.reps))"
        cell.cardThirdSectionLabel!.text = "\(String(detail.weight))"
        cell.cardDateLabel!.text = detail.date.toString()
        cell.cardDetailLabel!.text = "\(oneRepMax)"
        cell.backgroundColor = UIColor.clear
        cell.tintColor = Constants.themeColorWhite
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let exerciseDetail = exerciseDetails![indexPath.row]
            context.delete(exerciseDetail)
            exerciseDetails?.remove(at: indexPath.row)
            do {
                try context.save()
                tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
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
            showCloseButton: false, showCircularIcon: false, shouldAutoDismiss: false, contentViewColor:Constants.themeColorAlabuster
        )
        let alert = SCLAlertView(appearance: appearance)
        let repsInput = alert.addTextField(Constants.stringPlaceHolderReps)
        let setsInput = alert.addTextField(Constants.stringPlaceHolderSets)
        let weightInput = alert.addTextField(Constants.stringPlaceHolderWeight)
        repsInput.keyboardType = UIKeyboardType.numberPad
        setsInput.keyboardType = UIKeyboardType.numberPad
        weightInput.keyboardType = UIKeyboardType.numberPad
        
        
        var alertViewResponder = SCLAlertViewResponder(alertview: alert)
        
        alert.addButton(Constants.stringButtonAdd, backgroundColor: Constants.themeColorBlack, textColor: UIColor.white, showTimeout: nil) {
           //Validate data
            guard (repsInput.text != "" && setsInput.text != "" && weightInput.text != "") else{
                alertViewResponder.setSubTitle(Constants.stringWarningDataEmpty)
                return
            }
            guard let entity = NSEntityDescription.entity(forEntityName: Constants.CoreDataEntityType.ExerciseData.rawValue, in:self.context) else {
                return
            }
            let exerciseData = ExerciseData(entity: entity, insertInto:self.context)
            exerciseData.setValue(Int(repsInput.text!), forKey: "Reps")
            exerciseData.setValue(Int(setsInput.text!), forKey: "Sets")
            exerciseData.setValue(Int(weightInput.text!), forKey: "Weight")
            exerciseData.setValue(Date(), forKey: "Date")
            exerciseData.exercise = self.exercise
            let exerciseDatas = self.exercise.mutableOrderedSetValue(forKey: "exerciseData")
            exerciseDatas.insert(exerciseData, at: 0)
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Error saving movie \(error.localizedDescription)")
            }
            alert.hideView()
            self.exerciseDetails?.insert(exerciseData, at: 0)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [NSIndexPath(row: 0, section: 0) as IndexPath], with: .fade)
            self.tableView.endUpdates()
            
        }
        
        alert.addButton("Cancel", backgroundColor: Constants.themeColorMadderLake, textColor: UIColor.white, showTimeout: nil) {
            alert.hideView()
        }
        
        alertViewResponder =  alert.showTitle(Constants.stringAlertTitleAddWorkout,
                                                                   subTitle: Constants.stringAlertSubtitleEnterData,
                                                                   timeout: nil,
                                                                   completeText: Constants.stringButtonDone,
                                                                   style: .success,
                                                                   colorStyle: 0xFFFFFF,
                                                                   colorTextButton: 0xFFFFFF,
                                                                   circleIconImage: nil,
                                                                   animationStyle: .topToBottom)
        
        
        
        
    }
}
