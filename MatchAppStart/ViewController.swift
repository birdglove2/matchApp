//
//  ViewController.swift
//  MatchAppStart
//
//  Created by Krittamook Aksornchindarat on 21/7/2563 BE.
//  Copyright © 2563 Krittamook Aksornchindarat. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
    var gameEnd = true
   // var gameEnd2 = true
    let model = CardModel()
    var cardsArray = [Card]()
    var firstFlippedCardIndexPath:IndexPath?
    var cardOne:Card?
    var cardTwo:Card?
    
    weak var timer:Timer?
    var milliseconds:Int?
  //  var ThreeTwoOneTimerCheck:Bool = true
    var runOnlyOnce = true
    
    var soundPlayer:SoundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set the view controller as the datasource and delegate of the collection view
        CollectionView.dataSource = self
        CollectionView.delegate = self
        
        print("viewDidLoad")

        // Set func for restartButton
        restartButton.addTarget(self, action: #selector(self.restartGame), for: .touchUpInside)
        
        // Load the data
      
        loadgame();
        
        
    }
    
    //MARK: - Loading game data
    func loadgame() {
        if runOnlyOnce {
            run321Timer()
            runOnlyOnce = false
        }
        print("loadGame")
        // Set everything to start
        
        cardsArray = [Card]()
        firstFlippedCardIndexPath = nil
        cardOne = nil
        cardTwo = nil
        
       // restartButton.isHidden = true
      //  gameEnd = false
      //  gameEnd2 = false
        //runTimer()
       
        soundPlayer.playSound(effect: .shuffle,0)
        cardsArray = model.getCards() // shuffle cards
    
    }
    
    @objc func restartGame() {
        do {
            sleep(1)
        }
        run321Timer()
        loadgame()
        CollectionView.reloadData()
    }
    
    //MARK: - Timer Methods
    func run321Timer() {
        gameEnd = true
        print("run321Timer")
      
        timer?.invalidate()
        timeLabel.textColor = UIColor.blue
        milliseconds = 3 * 1000
    
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.timer321Fired), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: .common)
        
        //ThreeTwoOneTimerCheck = false
    }
    
    @objc func timer321Fired() {
        
        // Decrement the counter
        milliseconds! -= 1
        
        // Update the counter
        let seconds:Double = Double(milliseconds!)/1000.0
        timeLabel.text = String(format: "Game Start in: %.2f", seconds)
    
        if milliseconds! == 0 {
            timer?.invalidate()
            gameEnd = false
            runTimer()
        }
    }
    
    func runTimer() {
        // Stop the already-running timer -> prevent timer bug
        timer?.invalidate()
        
        // Reset time
        timeLabel.textColor = UIColor.black
        milliseconds = 5 * 1000
        
        // Run time again
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer!, forMode: .common)
        }
    }
    
    @objc func timerFired() {
        
        // Decrement the counter
        milliseconds! -= 1
        
        // Update the counter
        let seconds:Double = Double(milliseconds!)/1000.0
        timeLabel.text = String(format: "Time remaining: %.2f", seconds)
        
        // Stop if it reaches zero -> Game End
        if milliseconds! == 0 {
            timeLabel.textColor = UIColor.red
            timer?.invalidate()
            gameEnd = true
        }
        
        // Check For Game End ?
        checkForGameEnd()
        
    }
    
    
    //MARK: - Function of UICollectionViewDataSource Protocol ---------------------------------------//
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Asks your data source object for the number of items in the specified section.
        
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Asks your data source object for the cell that corresponds to the specified item in the collection view.
        
        // 1. Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
      /*  // 2. TODO: Configure it
        let eachCard = cardsArray[indexPath.row]
        cell.configureCell(eachCard)
      */
        
        // 3. Return it
        return cell
    }
    
    //MARK: - Function of UICollectionViewDelegate Protocol ---------------------------------------//

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("tapping \(gameEnd)" )
        // if game is not end -> user can click
        if gameEnd == true {
            print("returnnnnnnn")
            return
        }
        
        if gameEnd == false  {
            
            print("เล่นได้  \(gameEnd)")
        
            // Get a reference to the cell that was tapped
            let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
            
            // Flip the card
            if cell?.card?.isFlipped == false && cell?.card?.isMatched == false{
               
                cell?.flipUp()
                soundPlayer.playSound(effect: .flip,0)
                
                if firstFlippedCardIndexPath == nil {
                    
                    firstFlippedCardIndexPath = indexPath
                    
                }else{
                    
                    checkForMatched(indexPath)
                }
            }
        }
                    
    }
    
    // delegate will display to prevent recycling cell of xcode
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let eachCard = cardsArray[indexPath.row]
        let cardCell = cell as? CardCollectionViewCell
        cardCell?.configureCell(eachCard)
    }
       
    
    func checkForMatched(_ secondFlippedCardIndexPath:IndexPath) {
        soundPlayer.playSound(effect: .flip,0)
        cardOne = cardsArray[firstFlippedCardIndexPath!.row]
        cardTwo = cardsArray[secondFlippedCardIndexPath.row]
//        print("card 1 status : flip: \(cardOne?.isFlipped) , matched: \(cardOne?.isMatched), imageName: \(cardOne?.imageName)")
//        print("card 1 status : flip: \(cardTwo?.isFlipped) , matched: \(cardTwo?.isMatched), imageName: \(cardTwo?.imageName)")
        
        let cardOneCell = CollectionView.cellForItem(at: firstFlippedCardIndexPath!) as? CardCollectionViewCell
        let cardTwoCell = CollectionView.cellForItem(at: secondFlippedCardIndexPath) as? CardCollectionViewCell
        
        // Matched
        if cardOne!.imageName == cardTwo!.imageName {
            soundPlayer.playSound(effect: .wrong)
//            print("MATCHED !! card 1 status : flip: \(cardOne?.isFlipped) , matched: \(cardOne?.isMatched), imageName: \(cardOne?.imageName)")
//            print("MATCHED !! card 2 status : flip: \(cardTwo?.isFlipped) , matched: \(cardTwo?.isMatched), , imageName: \(cardTwo?.imageName)")
            cardOne!.isMatched = true
            cardTwo!.isMatched = true
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // is it the last pair ??
            checkForGameEnd()
            
        }else{
            soundPlayer.playSound(effect: .correct)
            
            cardOne!.isFlipped = false
            cardTwo!.isFlipped = false 
            
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        firstFlippedCardIndexPath = nil
    }
    
    func checkForGameEnd() {
        
        var hasWon = true
        
        for card in cardsArray {
            if card.isMatched == false {
                hasWon = false
                break
            }
        }
        // tips: "if condition? true:false"
        if hasWon {
            showAlert(title: "Congratulations!", message: "You've won the game")
            timer?.invalidate()
            gameEnd = true
            
        }else{
            // check if there is any time left or not
            if milliseconds == 0 {
                showAlert(title: "Time's up!", message: "Better luck next time")
                gameEnd = true
            }
        }
        
        if gameEnd { restartButton.isHidden = false }
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        alert.addAction(dismissAction)
        
        present(alert, animated: true)

    }
    
}


