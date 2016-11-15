//
//  Score.swift
//  Snek
//
//  Created by Luigi Sansonetti on 14.11.16.
//  Copyright © 2016 Luigi Sansonetti. All rights reserved.
//

import Foundation

class Score {
    
    // MARK: Properties
    
    var result: Int?
    var name: String?
    
    // MARK: Initializer
    
    init(result: Int, name: String) {
        self.result = result
        self.name = name
    }
}
