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
    static var leaderboard: Leaderboard?
    var receivedResult: Int?
    var name: String?
    
    // MARK: Loading
    
    override func viewDidLoad() {
        //self.leaderboard = Leaderboard()
        
        self.boardPopulation.isUserInteractionEnabled = false
        self.boardPopulation.text = ""
        // self.boardPopulation.font?.withSize(16)
        
        self.board.layer.borderColor = UIColor.black.cgColor
        self.board.layer.borderWidth = 1.0
        self.board.layer.backgroundColor = UIColor.white.withAlphaComponent(0.0).cgColor
        
        // Adding the new score to the leaderboard and displays
        promptNameIfNeeded()
    }
    
    // MARK: Score storage
    
    /// Prompts the user's name if needed
    func promptNameIfNeeded() {
        // Adding the score
        if self.receivedResult! > 0 && LeaderboardViewController.leaderboard!.newHighScore(newResult: receivedResult!) {
            // Creating the score
            let namePrompt = UIAlertController(title: "Wow, nicely done!", message: "You've got a new high score!", preferredStyle: UIAlertControllerStyle.alert)
            namePrompt.addTextField { (nameField) in
                nameField.text = UIDevice.current.name
            }
            namePrompt.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { (_) in
                let player = namePrompt.textFields![0].text
                self.handleScoreFor(player: player!)
            }))
            
            self.present(namePrompt, animated: true, completion: nil)
        } else {
            display()
        }
    }
    
    /// Inserts the score in the leaderboard and calls the display function
    func handleScoreFor(player: String) {
        self.name = player
        LeaderboardViewController.leaderboard!.addScore(newScore: Score(result: self.receivedResult!, name: self.name!))
        display()
    }
    
    /// Displays the leaderboard
    func display() {
        boardPopulation.text = LeaderboardViewController.leaderboard!.show()
    }
    
}
