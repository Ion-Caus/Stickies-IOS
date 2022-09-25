//
//  AudioManager.swift
//  Stickies
//
//  Created by Ion Caus on 13.09.2022.
//

import Foundation
import AVKit

class AudioManager : ObservableObject {
    var audioPlayer: AVPlayer?

    func playSound(sound: String){
        if let url = URL(string: sound) {
            self.audioPlayer = AVPlayer(url: url)
        }
    }
}
