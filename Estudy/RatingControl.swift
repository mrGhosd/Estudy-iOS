//
//  RatingControl.swift
//  Estudy
//
//  Created by vsokoltsov on 22.07.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

class RatingControl: UIView {
    // MARK: Properties
    
    var rating = 0
    var ratingButtons = [UIButton]()
    
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawButtons()
    }
    
    override func layoutSubviews() {
        var buttonFrame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        // Offset each button's origin by the length of the button plus spacing.
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (25 + 3))
            button.frame = buttonFrame
        }
    }
    
    func setRating(rate: Int!) {
        rating = rate
        drawButtons()
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 100, height: 25)
    }
    
    
    // MARK: Button Action
    
    func ratingButtonTapped(button: UIButton) {
        print("Button pressed 👍")
    }
    
    //MARK: Draw buttons
    func drawButtons() {
        if rating != 0 {
            for _ in 0..<rating {
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setBackgroundImage(UIImage(named: "Star"), forState: UIControlState.Normal)
                button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), forControlEvents: .TouchDown)
                ratingButtons += [button]
                addSubview(button)
            }
        }
    }
}