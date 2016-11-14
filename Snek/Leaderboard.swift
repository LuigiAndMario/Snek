//
//  Leaderboard.swift
//  Snek
//
//  Created by Luigi Sansonetti on 14.11.16.
//  Copyright © 2016 Luigi Sansonetti. All rights reserved.
//

import Foundation

class Leaderboard {
    var league: [Score?]?
    static let amount: Int = 5
    
    /// Adds a score to the leaderboard
    func addScore(newScore: Score) -> Bool {
        var inserted: Bool = false
        let newResult = newScore.result!
        
        // Inserts the current score in the league
        for i in 0..<Leaderboard.amount {
            if !inserted {
                let currentResult: Score = league![i]!
                if newResult >= currentResult.result! {
                    league!.insert(newScore, at: i)
                    inserted = true
                }
            }
        }
        
        cut()
        
        return inserted
    }
    
    /// Cuts all the scores after the last one of the leaderboard
    func cut() {
        var newLeague: [Score] = []
        for i in 0..<Leaderboard.amount {
            newLeague.insert(self.league![i]!, at: i)
        }
        
        self.league = newLeague
    }
    
}
