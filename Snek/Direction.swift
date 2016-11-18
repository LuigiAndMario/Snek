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
    
    /// Returns a boolean indicating whether the snek can change direction to newDirection
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
    
    /// Moves the snek in the correct direction and handles the toric box
    func move(from: Point, world: World) -> Point {
        var x = from.x
        var y = from.y
        
        switch self {
        case .left:
            x = (world.width + x - 1) % world.width
        case .right:
            x = (world.width + x + 1) % world.width
        case .up:
            y = (world.height + y + 1) % world.height
        case .down:
            y = (world.height + y - 1) % world.height
        }
        
        return Point(x: x, y: y)
    }
}
