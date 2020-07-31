//
//  CardModel.swift
//  MatchAppStart
//
//  Created by Krittamook Aksornchindarat on 21/7/2563 BE.
//  Copyright © 2563 Krittamook Aksornchindarat. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        //MARK: Declare an empty array
        var arrayOfCard:[Card] = [Card]()
        
        //MARK: Generate 8 pairs of cards
        var numOfCards = [1,2,3,4,5,6,7,8,9,10,11,12,13]
        var count = 0
        while count < 8  {
    
            // random number
            let randomNumber = Int.random(in: 0...numOfCards.count-1)
            
            // create a pair of cards
            let card1 = Card()
            let card2 = Card()
            card1.imageName = "card\(numOfCards[randomNumber])"
            card2.imageName = "card\(numOfCards[randomNumber])"
                   
            // append a pair of cards
            arrayOfCard += [card1,card2]
            
            // remove random numbers to prevent duplicate cards
            numOfCards.remove(at: randomNumber)
            
           // print(numOfCards)
            count+=1
            
        }
        
        //MARK: Randomize the cards within array
        arrayOfCard.shuffle()
        
        //MARK: Return the array
        return arrayOfCard
    }
}
