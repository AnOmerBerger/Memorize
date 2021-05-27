//
//  SoundForMemorize.swift
//  Memorize
//
//  Created by Omer on 5/16/21.
//

import Foundation
import AVFoundation



class BckgMusicPlayer {
    static let shared = BckgMusicPlayer()
    var audioPlayer: AVAudioPlayer?
    
    func startBckgMusic(name: String, type: String) {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.volume = 0.5
                audioPlayer?.play()
            } catch {
                print(error)
            }
        }
    }
    
    func stopBckgMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }
}



var SFXPlayer: AVAudioPlayer?

func playSoundEffect(name: String) {
    if let path = Bundle.main.path(forResource: name, ofType: "mp3") {
        do {
            SFXPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            SFXPlayer?.play()
        } catch {
            print(error)
        }
    }
}

func cardTouchSound() {
    let soundOptions = ["Card Touch 1", "Card Touch 2", "Card Touch 3", "Card Touch 4"]
    let randomSound = soundOptions[Int.random(in: 0...3)]
    if let path = Bundle.main.path(forResource: randomSound, ofType: "mp3") {
        do {
            SFXPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            SFXPlayer?.play()
        } catch {
            print(error)
        }
    }
}
