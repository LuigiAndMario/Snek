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
    
    @IBOutlet weak var board: UIView!
    @IBOutlet weak var boardPopulation: UITextView!
    static var leaderboard: Leaderboard?
    var receivedResult: Int?
    var name: String?
    
    // MARK: Loading
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        boardPopulation.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func viewDidLoad() {
        self.title = "Leaderboard"
        
        // Initialising the leaderboard in the current view
        if let savedLeaderboard = loadLeaderboard() {
            LeaderboardViewController.leaderboard = savedLeaderboard
        } else {
            LeaderboardViewController.leaderboard = Leaderboard(league: [])
        }
        
        self.boardPopulation.isUserInteractionEnabled = false
        self.boardPopulation.text = ""
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 20
        let attributes = [NSParagraphStyleAttributeName : style]
        boardPopulation.attributedText = NSAttributedString(string: boardPopulation.text, attributes:attributes)
        boardPopulation.setContentOffset(CGPoint.zero, animated: false)
        
        self.board.layer.borderColor = UIColor.black.cgColor
        self.board.layer.borderWidth = 1.0
        self.board.layer.backgroundColor = UIColor.white.withAlphaComponent(0.0).cgColor
        
        // Adding the new score to the leaderboard and displays
        promptNameIfNeeded()
    }
    
    // MARK: - Score storage
    
    weak var actionToEnable: UIAlertAction?
    
    /// Prompts the user's name if needed
    func promptNameIfNeeded() {
        // Adding the score
        if self.receivedResult! > 0 && LeaderboardViewController.leaderboard!.newHighScore(newResult: receivedResult!) {
            
            // Creating the score
            let namePrompt = UIAlertController(title: "Wow, nicely done!", message: "You've got a new high score!", preferredStyle: UIAlertControllerStyle.alert)
            
            namePrompt.addTextField { (nameField) in
                // nameField.text = ""
                nameField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            }
            
            let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { (_) in
                let player = namePrompt.textFields![0].text
                self.handleScoreFor(player: player!)
            })
            doneAction.isEnabled = false
            self.actionToEnable = doneAction
            
            namePrompt.addAction(doneAction)
            
            self.present(namePrompt, animated: true, completion: nil)
        } else {
            display()
        }
    }
    
    func textChanged(_ sender: UITextField) {
        self.actionToEnable?.isEnabled = (sender.text! != "")
    }
    
    /// Inserts the score in the leaderboard and calls the display function
    func handleScoreFor(player: String) {
        self.name = player
        LeaderboardViewController.leaderboard!.addScore(newScore: Score(name: self.name!, result: self.receivedResult!))
        display()
    }
    
    /// Displays the leaderboard
    func display() {
        saveLeaderboard()
        
        self.boardPopulation.text = LeaderboardViewController.leaderboard!.show()
        // Resets the style of the UITextView
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 20
        let attributes = [NSParagraphStyleAttributeName : style]
        boardPopulation.attributedText = NSAttributedString(string: boardPopulation.text, attributes:attributes)
        boardPopulation.setContentOffset(CGPoint.zero, animated: false)
    }
    
    // MARK: - NSCoding
    
    func saveLeaderboard() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(LeaderboardViewController.leaderboard!, toFile: Score.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save")
        }
    }
    
    func loadLeaderboard() -> Leaderboard? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Leaderboard.ArchiveURL.path) as? Leaderboard
    }
}
