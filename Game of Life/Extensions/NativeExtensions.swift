//
//  NativeExtensions.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 01/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        let range: ClosedRange<CGFloat> = 0.0...1.0

        return UIColor(displayP3Red: CGFloat.random(in: range), green: CGFloat.random(in: range), blue: CGFloat.random(in: range), alpha: 1)
    }
}
