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
    @IBOutlet var cardDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 5
        cardView.layer.masksToBounds = true
        
        
        cardView.addDropShadowToView(cardView)
        
        cardView.backgroundColor = Constants.themeColorBlack
        
        cardTitleLabel.textColor = Constants.themeColorWhite
        cardFirstSectionLabel.textColor = Constants.themeColorWhite
        cardSecondSectionLabel.textColor = Constants.themeColorWhite
        cardThirdSectionLabel.textColor = Constants.themeColorWhite
        cardDetailLabel.textColor = Constants.themeColorWhite

        
        cardTitleView.backgroundColor = UIColor.clearColor()
        cardSectionsView.backgroundColor = UIColor.clearColor()
        cardTitleView.addBorder(edges:[.Bottom], colour: Constants.themeColorAlabuster, thickness: 1) // All except Top, red, thickness 3
        
        //Add gradient to the background
        let colorTop =  Constants.themeColorBlack
        let colorBottom = UIColor.darkGrayColor()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.bounds
        
        self.layer.addSublayer(gradientLayer)
        
    }
    
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}