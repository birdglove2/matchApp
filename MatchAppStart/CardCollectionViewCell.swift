//
//  CardCollectionViewCell.swift
//  MatchAppStart
//
//  Created by Krittamook Aksornchindarat on 21/7/2563 BE.
//  Copyright © 2563 Krittamook Aksornchindarat. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    var card:Card?
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var cardName: UILabel!
    
    func configureCell(_ card: Card) {
        self.card = card
        frontImageView.image = UIImage(named: card.imageName)
        cardName.text = card.imageName
        
        // Reset the state of the cell by checking flipped status
        
        if card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }else{
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        if card.isFlipped == true{
            // show the front image view
            flipUp(0)
            
        }else{
            // show the back image view
            flipDown(0,0)
            
        }
        
        
        
    }
    
    func flipUp(_ speed:TimeInterval = 0.3) {
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft] ,completion: nil)
        self.card?.isFlipped = true
    }
    
    func flipDown(_ speed:TimeInterval = 0.3, _ delay:TimeInterval = 0.5) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+delay) {
        
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromRight], completion: nil)
            self.card?.isFlipped = false
        }
        
    }
    
    func remove(){
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
