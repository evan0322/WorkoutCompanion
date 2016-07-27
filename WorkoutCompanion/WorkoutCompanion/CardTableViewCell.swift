//
//  CardTableViewCell.swift
//  WorkoutCompanion
//
//  Created by WEI XIE on 2016-07-26.
//  Copyright © 2016 WEI.XIE. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardTitleView: UIView!
    @IBOutlet weak var cardSectionsView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardSecondSectionLabel: UILabel!
    @IBOutlet weak var cardThirdSectionLabel: UILabel!
    @IBOutlet weak var cardFirstSectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 15;
        cardView.layer.masksToBounds = true;
        cardView.layer.shadowColor = UIColor.blackColor().CGColor;
        cardView.layer.shadowOffset = CGSizeMake(0, 5);
        cardView.layer.shadowOpacity = 1;
        cardView.layer.shadowRadius = 1.0;
        cardTitleView.backgroundColor = UIColor.lightGrayColor()
        cardSectionsView.backgroundColor = UIColor.lightGrayColor()
        
        
        let border = CALayer()
        border.backgroundColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 10, y: cardTitleView.frame.height, width: cardTitleView.frame.width-10, height: 0.5)
        
        cardView.layer.addSublayer(border)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
