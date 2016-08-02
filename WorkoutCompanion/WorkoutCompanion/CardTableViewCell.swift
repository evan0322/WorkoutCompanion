//
//  CardTableViewCell.swift
//  WorkoutCompanion
//
//  Created by WEI XIE on 2016-07-26.
//  Copyright © 2016 WEI.XIE. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardThirdSectionView: UIView!
    @IBOutlet weak var cardSecondSectionView: UIView!
    @IBOutlet weak var cardFirstSectionView: UIView!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardTitleView: UIView!
    @IBOutlet weak var cardSectionsView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardSecondSectionLabel: UILabel!
    @IBOutlet weak var cardThirdSectionLabel: UILabel!
    @IBOutlet weak var cardFirstSectionLabel: UILabel!
    @IBOutlet var cardDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 5
        cardView.layer.masksToBounds = true
        
        
        cardView.addDropShadowToView(cardView)
        
        cardView.backgroundColor = Constants.themeColorWhite
        cardTitleView.backgroundColor = UIColor.clearColor()
        cardSectionsView.backgroundColor = UIColor.clearColor()
        cardTitleView.addBorder(edges:[.Bottom], colour: Constants.themeColorBlack, thickness: 1) // All except Top, red, thickness 3
        
    }
    
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}