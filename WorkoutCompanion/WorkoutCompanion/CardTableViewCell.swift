//
//  CardTableViewCell.swift
//  WorkoutCompanion
//
//  Created by WEI XIE on 2016-07-26.
//  Copyright © 2016 WEI.XIE. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 15;
        cardView.layer.masksToBounds = true;
        cardView.layer.shadowColor = UIColor.blackColor().CGColor;
        cardView.layer.shadowOffset = CGSizeMake(0, 5);
        cardView.layer.shadowOpacity = 1;
        cardView.layer.shadowRadius = 1.0;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
