//
//  ViewController.swift
//  Snek
//
//  Created by Luigi Sansonetti on 12.11.16.
//  Copyright © 2016 Luigi Sansonetti. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SnekViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var startAndPauseButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var gameBox: UIView!
    @IBOutlet weak var scoreCounter: UILabel!
    var snekView: SnekView?
    var timer: Timer?
    var snek: Snek?
    var fruit: Point?
    var gameState: GameState = GameState.notPlaying
    var score: Int = 0
    
    
    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Defining the box in which the snek will evolve
        // The size of the frame is as defined in the storyboard
        let frame = CGRect(x: 13, y: 120, width: 350, height: 350)
        
        // Setting the score counter to an empty string before staring to play
        scoreCounter.text = String("")
        
        // Hiding the restart button
        restartButton.isHidden = true
        
        gameBox.frame = frame
        gameBox.layer.borderColor = UIColor.black.cgColor
        gameBox.layer.borderWidth = 1.0
        // The background is set to a fully transparent gray in order to gray it out on a game over screen by increasing the alpha component
        gameBox.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.0).cgColor
        
        snekView = SnekView(frame: frame)
        // snekView!.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.view.insertSubview(self.snekView!, at: 0)
        
        if let view = self.snekView {
            view.delegate = self
        }
        
        for direction in [UISwipeGestureRecognizerDirection.right, UISwipeGestureRecognizerDirection.left, UISwipeGestureRecognizerDirection.up, UISwipeGestureRecognizerDirection.down] {
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
            gestureRecognizer.direction = direction
            self.view.addGestureRecognizer(gestureRecognizer)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Gestures
    
    /// Recognizes the gesture sent
    func swipe(gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.direction {
        case UISwipeGestureRecognizerDirection.left:
            if (self.snek?.changeDirection(newDirection: Direction.left) != nil) {
                self.snek?.lockDirection()
            }
        case UISwipeGestureRecognizerDirection.right:
            if (self.snek?.changeDirection(newDirection: Direction.right) != nil) {
                self.snek?.lockDirection()
            }
        case UISwipeGestureRecognizerDirection.up:
            if (self.snek?.changeDirection(newDirection: Direction.up) != nil) {
                self.snek?.lockDirection()
            }
        case UISwipeGestureRecognizerDirection.down:
            if (self.snek?.changeDirection(newDirection: Direction.down) != nil) {
                self.snek?.lockDirection()
            }
        default: break
        }
        
    }
    
    // MARK: Game
    
    /// Creates a new fruit on a random point of the world, and not under the snek
    func makeNewFruit() {
        let world = snek!.world
        var x = 0
        var y = 0
        var overlap: Bool = true
        
        // Determining the coordinates of the fruit
        while overlap {
            x = Int(arc4random_uniform(UInt32(world.width)))
            y = Int(arc4random_uniform(UInt32(world.height)))
            
            // Avoiding the case of placing a fruit under the snek
            overlap = false
            for point in snek!.points {
                if point.x == x && point.y == y {
                    overlap = true
                    break
                }
            }
        }
        
        fruit = Point(x: x, y: y)
    }
    
    /// Resolves the whole game
    func timerAction() {
        // Moves the snek
        snek?.move()
        
        // If the snek is dead, stops the game
        if snek!.die() {
            endGame()
            return
        }
        
        // If the snek eats the fruit, create a new fruit
        let head = snek!.points[0]
        if head.x == fruit!.x && head.y == fruit!.y {
            snek!.increaseSize(amountToAdd: 1)
            makeNewFruit()
            updateScore()
        }
        
        snek!.unlockDirection()
        snekView!.setNeedsDisplay()
        
    }
    
    func updateScore() {
        score = snek!.fruitsEaten
        scoreCounter.text = String(snek!.fruitsEaten)
    }
    
    // MARK: Button Actions
    
    /// Selects whether to start a new game or resume or pause the current game
    @IBAction func buttonAction(_ sender: UIButton!) {
        if gameState == GameState.notPlaying || gameState == GameState.gameOver {
            // New game
            startGame()
        } else if gameState == GameState.playing {
            // Pausing
            pauseGame()
        } else {
            // Resuming
            resumeGame()
        }
    }
    
    @IBAction func restartButtonAction(_ sender: UIButton) {
        if gameState == GameState.paused {
            endGame()
            startGame()
        }
    }
    
    func startGame() {
        startAndPauseButton.setTitle("Pause", for: .normal)
        restartButton.isHidden = true
        scoreCounter.text = String("0")
        
        // If the timer is not nil, then we have a problem
        if timer != nil {
            return
        }
        
        gameBox.backgroundColor? = UIColor.lightGray.withAlphaComponent(0.0)
        
        let world = World(width: 50, height: 50)
        snek = Snek(world: world, length: 2)
        makeNewFruit()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        snekView!.setNeedsDisplay()
        
        gameState = GameState.playing
    }
    
    func pauseGame() {
        startAndPauseButton.setTitle("Resume", for: .normal)
        restartButton.isHidden = false
        
        timer!.invalidate()
        gameBox.backgroundColor? = UIColor.lightGray.withAlphaComponent(0.5)
        
        gameState = GameState.paused
    }
    
    func resumeGame() {
        startAndPauseButton.setTitle("Pause", for: .normal)
        restartButton.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        gameBox.backgroundColor? = UIColor.lightGray.withAlphaComponent(0.0)
        
        gameState = GameState.playing
    }
    
    func endGame() {
        startAndPauseButton.setTitle("Start Playing!", for: .normal)
        
        timer!.invalidate()
        timer = nil
        
        gameBox.backgroundColor? = UIColor.lightGray.withAlphaComponent(0.5)
        
        gameState = GameState.gameOver
        score = snek!.fruitsEaten
    }
    
    // MARK: Inheritance
    
    func snekForSnekView(view: SnekView) -> Snek? {
        return snek
    }
    
    func fruitForSnekView(view: SnekView) -> Point? {
        return fruit
    }
}
