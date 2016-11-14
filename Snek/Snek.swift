//
//  Snek.swift
//  Snek
//
//  Created by Luigi Sansonetti on 12.11.16.
//  Copyright © 2016 Luigi Sansonetti. All rights reserved.
//

import Foundation

class Snek {
    
    // MARK: Properties
    
    let world: World
    var length: Int = 0
    var points: Array<Point> = []
    var direction: Direction = .left
    var lockedDirection = false
    var fruitsEaten = 0
    
    // MARK: Initialiser
    
    init(world: World, length: Int) {
        self.world = world
        self.length = length
        
        // Initial coordinates
        let xInit: Int = self.world.width / 2
        let yInit: Int = self.world.height / 2
        
        // Making the snek's body
        for i in 0...length {
            let point: Point = Point(x: xInit + i, y: yInit)
            points.append(point)
        }
        
        lockedDirection = false
    }
    
    // MARK: Movement
    
    func move() {
        self.points.removeLast()
        let head = self.direction.move(from: points[0], world: self.world)
        self.points.insert(head, at: 0)
    }
    
    func changeDirection(newDirection: Direction) {
        if self.direction.canChangeTo(newDirection: newDirection) && !lockedDirection {
            //self.direction = newDirection
            switch  newDirection {
            case .left:
                self.direction = .left
                break
            case .right:
                self.direction = .right
                break
            // Up and down must be swapped because of a bug
            case .up:
                self.direction = .down
                break
            case .down:
                self.direction = .up
                break
            }
        }
    }
    
    func increaseSize(amountToAdd: Int) {
        let endOfTail: Point = points[length - 1]
        let oneBeforeEndOfTail: Point = points[length - 2]
        let x: Int = (endOfTail.x - oneBeforeEndOfTail.x) % world.width
        let y: Int = (endOfTail.y - oneBeforeEndOfTail.y) % world.height
        
        // Appending the new point(s) to the snek
        for i in 0..<amountToAdd {
            let xOfNew: Int = (endOfTail.x + x*(i + 1)) % world.width
            let yOfNew: Int = (endOfTail.x + y*(i + 1)) % world.height
            points.append(Point(x: xOfNew, y: yOfNew))
        }
        
        // Updating the length of the snek
        length += amountToAdd
        fruitsEaten += 1
    }
    
    func lockDirection() {
        lockedDirection = true
    }
    
    func unlockDirection() {
        lockedDirection = false
    }
    
    // MARK: Die
    
    func die() -> Bool {
        let head = points[0]
        let x = head.x
        let y = head.y
        
        // If the head is on a body part, then the snek dies
        for bodyPart in points[1..<length] {
            if x == bodyPart.x && y == bodyPart.y {
                return true
            }
        }
        return false
    }
    
}
