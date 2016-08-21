//
//  UIManager.swift
//  WorkoutCompanion
//
//  Created by Wei Xie on 2016-08-19.
//  Copyright © 2016 WEI.XIE. All rights reserved.
//

import UIKit
import ScrollableGraphView

class UIManager: NSObject {
    
    private static let _sharedInstance = UIManager()
    
    class func sharedInstance() -> UIManager {
        return _sharedInstance
    }
    
    func handleNoDataLabel (add:Bool,forTableView tableView:UITableView){
        if add {
            let noDataLabel: UILabel     = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            
            let attrs = [NSForegroundColorAttributeName: UIColor.lightGrayColor(),
                         NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 24)!,
                         NSTextEffectAttributeName: NSTextEffectLetterpressStyle]
            
            noDataLabel.attributedText   =  NSAttributedString(string: "No Data", attributes: attrs)
            noDataLabel.textAlignment    = .Center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .None
            

        } else {
            tableView.backgroundView = nil
        }
        
    }
    
    func generateScrollableGraphViewViewWithFrame(frame:CGRect, data:[Double], labels:[String]) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame: frame)
        graphView.backgroundFillColor = Constants.themeColorHarvardCrimson
        
        graphView.rangeMax = 50
        
        graphView.lineColor = UIColor.redColor()
        graphView.lineWidth = 1
        graphView.lineColor = Constants.themeColorAlabuster
        graphView.lineStyle = ScrollableGraphViewLineStyle.Smooth
        
        graphView.leftmostPointPadding = CGFloat(30)
        
        
        
        graphView.dataPointSpacing = 60
        graphView.dataPointSize = 2
        graphView.dataPointFillColor = Constants.themeColorAlabuster
        
        graphView.referenceLineLabelFont = UIFont.boldSystemFontOfSize(8)
        graphView.referenceLineColor = Constants.themeColorAlabuster.colorWithAlphaComponent(0.2)
        graphView.referenceLineLabelColor = Constants.themeColorAlabuster
        graphView.dataPointLabelColor = Constants.themeColorAlabuster.colorWithAlphaComponent(0.5)
        
        graphView.shouldAdaptRange = true
        graphView.shouldAutomaticallyDetectRange = true
        
        graphView.setData(data, withLabels: labels)
        
        
        return graphView
    }
    

}
