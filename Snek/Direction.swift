//
//  Direction.swift
//  Snek
//
//  Created by Luigi Sansonetti on 12.11.16.
//  Copyright © 2016 Luigi Sansonetti. All rights reserved.
//

import Foundation

enum Direction: Int {
    case left = 1
    case right = 2
    case up = 3
    case down = 4
    
    func canChangeTo(newDirection: Direction) -> Bool {
        var canChange = false
        
        // Determines whether the snek can change direction or not.
        // If the snek is on ±x, it can go to ±y and not ±x, and the other way round
        switch self {
        case .left, .right:
            canChange = newDirection == .up || newDirection == .down
        case .up, .down:
            canChange = newDirection == .left || newDirection == .right
        }
        
        return canChange
    }
    
    func move(from: Point, world: World) -> Point {
        var x = from.x
        var y = from.y
        
        // Adjusts the coordinates depending on the borderline cases
        switch self {
        case .left:
            x = x - 1
            // Going left when at the leftmost point
            if x < 0 {
                // Reappearing on the right
                x = world.width
            }
        case .right:
            x = x + 1
            // Going right when at the rightmost point
            if x > world.width {
                // Reappearing on the left
                x = 0
            }
        case .up:
            y = y + 1
            // Going up when at the upmost point
            if y > world.height {
                // Reappearing down
                y = 0
            }
        case .down:
            y = y - 1
            // Going up down at the downmost point
            if y < 0 {
                // Reappearing up
                y = world.height
            }
        }
        
        return Point(x: x, y: y)
    }
}
