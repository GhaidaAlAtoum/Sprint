//
//  SoundManager.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/15/24.
//

import Foundation
import SpriteKit
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    static let soundTrack = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    
    var soundEnabled:Bool = true
    
    func playAudio(audio: String, loop: Bool, volume: Float) {
        if (soundEnabled) {
            guard let audioURL = Bundle.main.url(forResource: audio, withExtension: "mp3")
            else {return}
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                audioPlayer?.volume = volume
                audioPlayer?.numberOfLoops = loop ? -1 : 0
                audioPlayer?.play()
            } catch {
                print("Couldn't play audio. Error \(error)")
            }
        } else {
            stopSounds()
        }
    }
    
    func stopSounds() {
        audioPlayer?.stop()
    }
    
    func toggleSound() {
        self.soundEnabled.toggle()
    }
    
    func isSoundOn() -> Bool {
        return self.soundEnabled
    }
    
    func playSoundTrack() {
        SoundManager.shared.playAudio(audio: "retroBackgroundMusic", loop: true, volume: 0.3)
    }
}
