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
    
    func generateScrollableGraphViewViewWithFrame(frame:CGRect, data:[Double], labels:[String]) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame: frame)
        graphView.backgroundFillColor = Constants.themeColorHarvardCrimson
        graphView.shouldAdaptRange = true
        graphView.shouldAnimateOnAdapt = true
        graphView.shouldAnimateOnStartup = true
        graphView.rangeMax = 50
        
        graphView.tintColor = UIColor.red
        
        for i in 0..<data.count {
            let linePlot = LinePlot(identifier: "line\(i)") // Identifier should be unique for each plot.
            linePlot.lineWidth = 1
            linePlot.lineColor = Constants.themeColorAlabuster
            linePlot.lineStyle = .smooth
            graphView.addPlot(plot: linePlot)
        }
        
        let referenceLines = ReferenceLines()
        referenceLines.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = Constants.themeColorAlabuster.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = Constants.themeColorAlabuster
        referenceLines.dataPointLabelColor = Constants.themeColorAlabuster.withAlphaComponent(0.5)
        graphView.addReferenceLines(referenceLines: referenceLines)

        
        graphView.leftmostPointPadding = CGFloat(30)
        
        graphView.dataPointSpacing = 60
        graphView.dataPointSpacing = 2
        graphView.backgroundFillColor = Constants.themeColorAlabuster

        
        let dataSource = CellDataSource(values: data, labels: labels)
    
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
