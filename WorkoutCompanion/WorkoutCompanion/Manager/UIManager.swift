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
//        if add {
//            let noDataLabel: UILabel     = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
//
//            let attrs = [NSForegroundColorAttributeName: UIColor.lightGrayColor,
//                         NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 24)!,
//                         NSTextEffectAttributeName: NSTextEffectLetterpressStyle]
//
//            noDataLabel.attributedText   =  NSAttributedString(string: "No Data", attributes: attrs)
//            noDataLabel.textAlignment    = .center
//            tableView.backgroundView = noDataLabel
//
//
//        } else {
//            tableView.backgroundView = nil
//        }
        
    }
    
    func generateScrollableGraphViewViewWithFrame(data:[Double], labels:[String]) -> ScrollableGraphView {
        let graphView = ScrollableGraphView()
        graphView.backgroundFillColor = Constants.themeColorHarvardCrimson
        
        graphView.rangeMax = 50
        
        graphView.tintColor = UIColor.red
//        graphView.lineWidth = 1
//        graphView.lineColor = Constants.themeColorAlabuster
//        graphView.lineStyle = ScrollableGraphViewLineStyle.Smooth
        
        graphView.leftmostPointPadding = CGFloat(30)
        
        graphView.dataPointSpacing = 60
        graphView.dataPointSpacing = 2
        graphView.backgroundFillColor = Constants.themeColorAlabuster
        
//        graphView.referenceLineLabelFont = UIFont.boldSystemFontOfSize(8)
//        graphView.referenceLineColor = Constants.themeColorAlabuster.colorWithAlphaComponent(0.2)
//        graphView.referenceLineLabelColor = Constants.themeColorAlabuster
//        graphView.dataPointLabelColor = Constants.themeColorAlabuster.colorWithAlphaComponent(0.5)
        
        let dataSource = CellDataSource(values: data, labels: labels)
        
//        graphView.shouldAdaptRange = true
//        graphView.shouldAutomaticallyDetectRange = true
//
        graphView.dataSource = dataSource
        
        
        return graphView
    }
    

}

class CellDataSource: ScrollableGraphViewDataSource {
    var values: [Double]
    var labels: [String]
    
    init(values:[Double], labels:[String]) {
        self.values = values
        self.labels = labels
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        return self.values[pointIndex]
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return self.labels[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return self.values.count
    }
    
    
}
