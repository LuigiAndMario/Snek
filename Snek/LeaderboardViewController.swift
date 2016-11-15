//
//  LeaderboardViewController.swift
//  Snek
//
//  Created by Luigi Sansonetti on 14.11.16.
//  Copyright © 2016 Luigi Sansonetti. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var leaderboardLabel: UILabel!
    @IBOutlet weak var board: UIView!
    @IBOutlet weak var boardPopulation: UITextView!
    var leaderboard: Leaderboard?
    var receivedResult: Int?
    var name: String?
    
    // MARK: Loading
    
    override func viewDidLoad() {
        self.leaderboard = Leaderboard()
        self.boardPopulation.isUserInteractionEnabled = false
        self.boardPopulation.text = ""
        
        self.board.layer.borderColor = UIColor.black.cgColor
        self.board.layer.borderWidth = 1.0
        self.board.layer.backgroundColor = UIColor.white.withAlphaComponent(0.0).cgColor
        
        handleScore()
        
        // display()
    }
    
    // MARK: Score storage
    
    /// Inserts the score in the leaderboard if needed
    func handleScore() {
        // Adding the score
        if self.receivedResult! > 0 && leaderboard!.newHighScore(newResult: receivedResult!) {
            // Creating the score
            let namePrompt = UIAlertController(title: "Wow, nicely done!", message: "You've got a new high score!", preferredStyle: UIAlertControllerStyle.alert)
            namePrompt.addTextField { (nameField) in
                nameField.text = UIDevice.current.name
            }
            namePrompt.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { (_) in
                let player = namePrompt.textFields![0].text
                self.dealWithNewScore(name: player!)
            }))
            
            self.present(namePrompt, animated: true, completion: nil)
        } else {
            display()
        }
    }
    
    func dealWithNewScore(name: String) {
        self.name = name
        self.leaderboard!.addScore(newScore: Score(result: self.receivedResult!, name: self.name!))
        display()
    }
    
    /// Displays the leaderboard
    func display() {
        boardPopulation.text = self.leaderboard!.show()
    }
    
}
