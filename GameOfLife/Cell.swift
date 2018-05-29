//
//  Cell.swift
//  GameOfLife
//
//  Created by Bipin Gohel on 19.05.18.
//  Copyright © 2018 Bipin Gohel. All rights reserved.
//

import UIKit

// Drwas a square with given frame in View 

class Cell: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    override func draw(_ rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: CGPoint(x: frame.origin.x, y: frame.origin.y))
        context?.addLine(to: CGPoint(x: frame.origin.x + frame.width , y: frame.origin.y))
        context?.addLine(to: CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y+frame.height))
        context?.addLine(to: CGPoint(x: frame.origin.x, y: frame.origin.y+frame.height))
        context?.addLine(to: CGPoint(x: frame.origin.x, y: frame.origin.y))
        context?.setFillColor(UIColor.blue.cgColor)
        context?.fillPath()
    }

}
