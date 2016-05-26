//
//  ESUILabel.swift
//  Estudy
//
//  Created by vsokoltsov on 26.05.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation
import UIKit

class ESUILabel : UILabel {
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}