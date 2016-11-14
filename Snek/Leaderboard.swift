//
//  Leaderboard.swift
//  Snek
//
//  Created by Luigi Sansonetti on 14.11.16.
//  Copyright © 2016 Luigi Sansonetti. All rights reserved.
//

import Foundation

class Leaderboard {
    
    // MARK: Properties
    
    var league: [Score]
    static let amount: Int = 5
    
    // MARK: Initializer
    
    init() {
        self.league = []
        //for i in 0..<Leaderboard.amount {
        //    league.insert(Score(result: 0, nameOfPlayer: ""), at: i)
        //}
    }
    
    // MARK: Browsing
    
    /// Returns a boolean determining whether newScore is a new high score
    func newHighScore(newResult: Int) -> Bool {
        for score in self.league {
            if newResult > score.result! {
                return true
            }
        }
        
        return self.league.isEmpty
    }
    
    /// Returns a displayable version of the leaderboard
    func show() -> String {
        var s: String = ""
        let upTo = Math.min(a: Leaderboard.amount, b: league.count)
        for i in 0..<upTo {
            let currentScore = league[i]
            s = String(i) + ".  "
            s += currentScore.nameOfPlayer! + " : "
            s += String(describing: currentScore.result) + " fruits eaten"
            s += "\n"
        }
        
        return s
    }
    
    // MARK: Addition
    
    /// Adds a score to the leaderboard
    func addScore(newScore: Score) -> Bool {
        
        // If there are no high scores, we simply add one and return
        if league.isEmpty {
            league.insert(newScore, at: 0)
            return true
        }
        
        var inserted: Bool = false
        let newResult = newScore.result!
        
        // Inserts the current score in the league
        let upTo = Math.min(a: Leaderboard.amount, b: league.count)
        for i in 0..<upTo {
            if !inserted {
                let currentResult: Score = self.league[i]
                if newResult >= currentResult.result! {
                    self.league.insert(newScore, at: i)
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
        let upTo = Math.min(a: Leaderboard.amount, b: league.count)
        for i in 0..<upTo {
            newLeague.insert(self.league[i], at: i)
        }
        
        self.league = newLeague
    }
    
}
