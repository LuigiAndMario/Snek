//
//  SnekView.swift
//  Snek
//
//  Created by Luigi Sansonetti on 12.11.16.
//  Copyright © 2016 Luigi Sansonetti. All rights reserved.
//

import UIKit

class SnekView : UIView {
    
    // MARK: Properties
    
    var delegate: SnekViewDelegate?
    
    // MARK: Initialisers
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        self.backgroundColor = UIColor.white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    // MARK: Drawing
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let snek: Snek = delegate?.snekForSnekView(view: self) {
            let world = snek.world
            
            // Determines the unplayable conditions
            if world.width <= 0 || world.height <= 0 {
                return
            }
            
            // Width and height of a point of the grid (world)
            let w = Int(Float(self.bounds.width) / Float(world.width))
            let h = Int(Float(self.bounds.height) / Float(world.height))
            
            let points = snek.points
            
            // Paints the head of the snek
            UIColor.gray.set()
            let rect = CGRect(x: points[0].x * w, y: points[0].y * h, width: w, height: h)
            UIBezierPath(rect: rect).fill()

            // Paints the body of the snek
            UIColor.black.set()
            for point in points[1..<points.count] {
                // Draws the points of the snek
                let rect = CGRect(x: point.x * w, y: point.y * h, width: w, height: h)
                UIBezierPath(rect: rect).fill()
            }
            
            // Paints the fruit
            if let fruit = delegate?.fruitForSnekView(view: self) {
                UIColor.purple.set()
                let rect = CGRect(x: fruit.x * w, y: fruit.y * h, width: w, height: h)
                UIBezierPath(ovalIn: rect).fill()
            }
        }
    }
    
}
