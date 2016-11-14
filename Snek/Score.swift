//
//  Score.swift
//  Snek
//
//  Created by Luigi Sansonetti on 14.11.16.
//  Copyright © 2016 Luigi Sansonetti. All rights reserved.
//

import Foundation

class Score {
    var result: Int?
    var nameOfPlayer: String?
    
    init(result: Int, nameOfPlayer: String) {
        self.result = result
        self.nameOfPlayer = nameOfPlayer
    }
}
