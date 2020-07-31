//
//  SoundManager.swift
//  MatchAppStart
//
//  Created by Krittamook Aksornchindarat on 24/7/2563 BE.
//  Copyright © 2563 Krittamook Aksornchindarat. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var player:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case correct
        case wrong
        case shuffle
    }
    
    func playSound(effect:SoundEffect, _ delaytime:TimeInterval = 0.5) {
        
        var soundFileName = ""
        
        switch effect {
            case .flip: soundFileName = "cardflip"
            case .correct: soundFileName = "dingcorrect"
            case .wrong: soundFileName = "dingwrong"
            case .shuffle: soundFileName = "shuffle"
        }
        
       guard let url = Bundle.main.url(forResource: soundFileName, withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + delaytime) { // Change `0.5` to the desired number of seconds.
               // Code you want to be delayed
                player.play()
            }
           

        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}

