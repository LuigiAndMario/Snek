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
    @IBOutlet weak var board: UITextField!
    var leaderboard: Leaderboard?
    var receivedScore: Int?
    var name: String?
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leaderboard = Leaderboard()
        
        // Populate the leaderboard
    }
    
    // MARK: Score computation
    
    /// Inserts the score in the leaderboard if needed
    func handleScore() {
        // Adding the score
        if leaderboard!.newHighScore(newResult: receivedScore!) {
            // Creating the score
            let namePrompt = UIAlertController(title: "Wow, nicely done!", message: "You've got a new high score!", preferredStyle: UIAlertControllerStyle.alert)
            namePrompt.addTextField { (nameField) in
                nameField.text = UIDevice.current.name
            }
            namePrompt.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { (_) in
                self.name = namePrompt.textFields![0].text
                self.leaderboard!.addScore(newScore: Score(result: self.receivedScore!, nameOfPlayer: self.name!))
            }))
            
            self.present(namePrompt, animated: true, completion: nil)
        }
    }
    
}
