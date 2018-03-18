//
//  CardTableViewCell.swift
//  WorkoutCompanion
//
//  Created by WEI XIE on 2016-07-26.
//  Copyright © 2016 WEI.XIE. All rights reserved.
//

import UIKit
import ScrollableGraphView

class CardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardThirdSectionView: UIView?
    @IBOutlet weak var cardSecondSectionView: UIView?
    @IBOutlet weak var cardFirstSectionView: UIView?
    @IBOutlet weak var cardTitleLabel: UILabel?
    @IBOutlet weak var cardTitleView: UIView?
    @IBOutlet weak var cardSectionsView: UIView?
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var cardSecondSectionLabel: UILabel?
    @IBOutlet weak var cardThirdSectionLabel: UILabel?
    @IBOutlet weak var cardFirstSectionLabel: UILabel?
    @IBOutlet var cardDateLabel: UILabel?
    @IBOutlet var cardDetailLabel: UILabel?
    @IBOutlet var cardGraphView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 5
        cardView.layer.masksToBounds = true
        self.selectionStyle = UITableViewCellSelectionStyle.none
        cardView.backgroundColor = Constants.themeColorHarvardCrimson
        
        cardTitleLabel?.textColor = Constants.themeColorWhite
        cardFirstSectionLabel?.textColor = Constants.themeColorWhite
        cardSecondSectionLabel?.textColor = Constants.themeColorWhite
        cardThirdSectionLabel?.textColor = Constants.themeColorWhite
        cardDetailLabel?.textColor = Constants.themeColorWhite
        cardDateLabel?.textColor = UIColor.lightGrayColor
        cardGraphView?.backgroundColor = UIColor.clearColor
        cardTitleView?.backgroundColor = UIColor.clearColor
        cardSectionsView?.backgroundColor = UIColor.clearColor
        cardTitleView?.addBorder(edges:[.bottom], colour: Constants.themeColorAlabuster, thickness: 1) // All except Top, red, thickness 3
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
