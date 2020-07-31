//
//  ViewController.swift
//  MatchAppStart
//
//  Created by Krittamook Aksornchindarat on 21/7/2563 BE.
//  Copyright © 2563 Krittamook Aksornchindarat. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    
    @IBOutlet weak var restartButton: UIButton!
    var gameEnd = false
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    var firstFlippedCardIndexPath:IndexPath?
    var cardOne:Card?
    var cardTwo:Card?
    
    var timer:Timer?
    var milliseconds:Int = 3 * 1000
    
    var soundPlayer:SoundManager = SoundManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewDidLoad")
        restartButton.addTarget(self, action: #selector(self.loadData), for: .touchUpInside)

        // Load the data
        self.loadData();
        
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear")
     //   let myButton = UIButton()

        // When user touch myButton, we're going to call loadData method
      //  restartButton.addTarget(self, action: #selector(self.loadData), for: .touchUpInside)

        // Load the data
        //self.loadData();
    }
    @objc func loadData() {
        // code to load data from network, and refresh the interface
        if gameEnd {
                   print("game end is true")
                   restartButton.isHidden = false
               }else {
                    print("game end is false")
                   restartButton.isHidden = true
               }
        loadeiei()
        CollectionView.reloadData()
    }
    
    func loadeiei() {
        gameEnd = false
        milliseconds = 2 * 1000
        cardsArray = [Card]()
        
        soundPlayer.playSound(effect: .shuffle,0)
        //restartButton.isHidden = true
        cardsArray = model.getCards() // shuffle cards
     
        print(cardsArray)
        
        // Set the view controller as the datasource and delegate of the collection view
        CollectionView.dataSource = self
        CollectionView.delegate = self
        
        // Initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
  /* override func viewDidAppear(_ animated: Bool) {
        soundPlayer.playSound(effect: .shuffle,0.3)
    }*/
   
    //MARK: - Timer Methods
    @objc func timerFired() {
        
        // Decrement the counter
        milliseconds -= 1
        
        // Update the counter
        let seconds:Double = Double(milliseconds)/1000.0
        timeLabel.text = String(format: "Time remaining: %.2f", seconds)
        
        // Stop if it reaches zero
        if milliseconds == 0 {
            timeLabel.textColor = UIColor.red
            timer?.invalidate()
        }
        
        // Check if the user has cleared all the pairs
        checkForGameEnd()
        
       /* if gameEnd {
            restartButton.isHidden = false
            restartButton.addTarget(self, action: "buttonClicked:", for: .touchUpInside)
        }*/
       
        
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
    //---------------------------------------------------------------------------------------------//

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !gameEnd {
        
            // Get a reference to the cell that was tapped
            let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
            
            /*let eachCard = cardsArray[indexPath.row]
            let cardCell = cell as? CardCollectionViewCell
            cardCell?.configureCell(eachCard)
 */
     //       cell!.configureCell(cell!.card!)
            
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
        print("card 1 status : flip: \(cardOne?.isFlipped) , matched: \(cardOne?.isMatched), imageName: \(cardOne?.imageName)")
        print("card 1 status : flip: \(cardTwo?.isFlipped) , matched: \(cardTwo?.isMatched), imageName: \(cardTwo?.imageName)")
        
        let cardOneCell = CollectionView.cellForItem(at: firstFlippedCardIndexPath!) as? CardCollectionViewCell
        let cardTwoCell = CollectionView.cellForItem(at: secondFlippedCardIndexPath) as? CardCollectionViewCell
        
        // Matched
        if cardOne!.imageName == cardTwo!.imageName {
            soundPlayer.playSound(effect: .wrong)
            print("MATCHED !! card 1 status : flip: \(cardOne?.isFlipped) , matched: \(cardOne?.isMatched), imageName: \(cardOne?.imageName)")
            print("MATCHED !! card 2 status : flip: \(cardTwo?.isFlipped) , matched: \(cardTwo?.isMatched), , imageName: \(cardTwo?.imageName)")
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
            restartButton.isHidden = false
            
        }else{
            // check if there is any time left or not
            if milliseconds == 0 {
                showAlert(title: "Time's up!", message: "Better luck next time")
                gameEnd = true
                restartButton.isHidden = false
                
            }
        }
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        alert.addAction(dismissAction)
        
        present(alert, animated: true)
        
        
    }
    
}


