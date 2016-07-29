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
        cardView.layer.cornerRadius = 5
        cardView.layer.masksToBounds = true
        
        
        cardView.addDropShadowToView(cardView)
        
        
        
        cardView.backgroundColor = Constants.themeColorWhite
        cardTitleView.backgroundColor = Constants.themeColorWhite
        cardSectionsView.backgroundColor = Constants.themeColorWhite
        cardTitleView.addBorder(edges:[.Bottom], colour: Constants.themeColorBlack, thickness: 1) // All except Top, red, thickness 3
        
    }
    
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension UIView
{
    func addBorder(edges edges: UIRectEdge, colour: UIColor = UIColor.whiteColor(), thickness: CGFloat = 1) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRectZero)
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.Top) || edges.contains(.All) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[top(==thickness)]",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[top]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.Left) || edges.contains(.All) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[left(==thickness)]",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[left]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.Right) || edges.contains(.All) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:[right(==thickness)]-(0)-|",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[right]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.Bottom) || edges.contains(.All) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:[bottom(==thickness)]-(0)-|",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[bottom]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
    }
    
    func addDropShadowToView(targetView:UIView? ){
        targetView!.layer.masksToBounds =  false
        targetView!.layer.shadowColor = Constants.themeColorCultured.CGColor;
        targetView!.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        targetView!.layer.shadowOpacity = 1.0
    }
}
