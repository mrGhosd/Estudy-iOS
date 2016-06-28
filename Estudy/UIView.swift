//
//  UIView.swift
//  Estudy
//
//  Created by vsokoltsov on 28.06.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}