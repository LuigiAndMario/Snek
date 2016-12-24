//
//  Leaderboard.swift
//  Snek
//
//  Created by Luigi Sansonetti on 14.11.16.
//  Copyright © 2016 Luigi Sansonetti. All rights reserved.
//

import Foundation

class Leaderboard: NSObject, NSCoding {
    
    // MARK: Properties
    
    var league: [Score]
    static let Amount: Int = 10
    
    // MARK: Initializer
    
    init(league: [Score]) {
        if league.isEmpty {
            self.league = []
            for i in 0..<Leaderboard.Amount {
                self.league.insert(Score(name: "Unnamed", result: -1), at: i)
            }
        } else {
            self.league = league
        }
        
        super.init()
    }
    
    // MARK: - Browsing
    
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
        for i in 0..<Leaderboard.Amount {
            let currentScore = league[i]
            if currentScore.result! >= 0 {
                s += String(i + 1) + ".  "   // Position
                s += currentScore.name! + " : " // Name
                s += String(describing: currentScore.result!) // Result
                if currentScore.result! == 1 {
                    s += " fruit eaten"
                } else {
                    s += " fruits eaten"
                }
                s += "\r"
            }
        }
        
        return s
    }
    
    // MARK: Addition
    
    /// Adds a score to the leaderboard
    func addScore(newScore: Score) {
        
        // If there are no high scores, we simply add one and return
        if league.isEmpty {
            league.insert(newScore, at: 0)
        }
        
        let newResult = newScore.result!
        
        // Inserts the current score in the league
        for i in 0..<Leaderboard.Amount {
            let currentResult: Score = self.league[i]
            if newResult >= currentResult.result! {
                self.league.insert(newScore, at: i)
                break
            }
        }
        
        cut()
    }
    
    /// Cuts all the scores after the last one of the leaderboard
    func cut() {
        var newLeague: [Score] = []
        for i in 0..<Leaderboard.Amount {
            newLeague.insert(self.league[i], at: i)
        }
        
        self.league = newLeague
    }
    
    // MARK: - Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("scores")
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(league, forKey: PropertyKey.leagueKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let league = aDecoder.decodeObject(forKey: PropertyKey.leagueKey) as! [Score]
        
        self.init(league: league)
    }
    
}
