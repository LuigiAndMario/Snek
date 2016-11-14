//
//  Maths.swift
//  Snek
//
//  Created by Luigi Sansonetti on 14.11.16.
//  Copyright © 2016 Luigi Sansonetti. All rights reserved.
//

import Foundation

/// Helper structure containing mathematical functions
struct Math {
   
    /// Returns the minimum of two integers a and b
    static func min(a: Int, b: Int) -> Int {
        if a < b {
            return a
        } else {
            return b
        }
    }
}
