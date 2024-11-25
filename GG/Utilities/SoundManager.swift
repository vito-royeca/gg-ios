//
//  SoundManager.swift
//  GG
//
//  Created by Vito Royeca on 11/24/24.
//

import Foundation
import AVFoundation
import SwiftUI

class SoundManager: NSObject, AVAudioPlayerDelegate {
    static var shared: SoundManager = SoundManager()
    
    // MARK: - Properties

    @AppStorage("playBackgroundMusic") var shouldPlayBackgroundMusic: Bool = true
    @AppStorage("playSoundEffects") var shouldPlaySoundEffects: Bool = true
    
    private var backgroundMusic: AVAudioPlayer?
    private var currentBackgroundMusic: String = ""
    private var backgroundSound: AVAudioPlayer?
    private var soundEffects = [URL: AVAudioPlayer]()
    private var spareSoundEffects = [AVAudioPlayer]()
    
    // MARK: - Methods
    
    func startBackgroundMusic(song: String) {
        guard shouldPlayBackgroundMusic else {
            return
        }
        
        guard currentBackgroundMusic != song else {
            return
        }
        
        if let backgroundMusic = backgroundMusic {
            if backgroundMusic.isPlaying {
                stopBackgroundMusic()
            }
        }
        
        if let path = Bundle.main.path(forResource: song, ofType:nil) {
            let url = URL(fileURLWithPath: path)
            
            do {
                currentBackgroundMusic = song
                backgroundMusic = try AVAudioPlayer(contentsOf: url)
                backgroundMusic?.volume = 0.30
                backgroundMusic?.numberOfLoops = -1
                backgroundMusic?.play()
            } catch {
                print("Unable to play background music: \(error)")
            }
        } else {
            print("Unable find background music: \(song)")
        }
    }
    
    func playBackgroundSound(sound: String) {
        
        guard shouldPlayBackgroundMusic else {
            return
        }
        
        if let backgroundSound = backgroundSound {
            if backgroundSound.isPlaying {
                stopBackgroundSound()
            }
        }
        
        if let path = Bundle.main.path(forResource: sound, ofType:nil) {
            let url = URL(fileURLWithPath: path)
            
            do {
                backgroundSound = try AVAudioPlayer(contentsOf: url)
                backgroundSound?.play()
            } catch {
                print("Unable to play background music: \(error)")
            }
        } else {
            print("Unable find background music: \(sound)")
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusic?.stop()
        currentBackgroundMusic = ""
        backgroundMusic = nil
    }
    
    func stopBackgroundSound() {
        backgroundSound?.stop()
        backgroundSound = nil
    }
    
    
    func playSoundEffect(sound: String) {
        
        guard shouldPlaySoundEffects else {
            return
        }
        
        if let path = Bundle.main.path(forResource: sound, ofType:nil) {
            let url = URL(fileURLWithPath: path)
            
            do {
                if let player = soundEffects[url] {
                    if player.isPlaying == false {
                        player.prepareToPlay()
                        player.play()
                    } else {
                        let duplicatePlayer = try! AVAudioPlayer(contentsOf: url)
                        duplicatePlayer.delegate = self
                        spareSoundEffects.append(duplicatePlayer)
                        duplicatePlayer.prepareToPlay()
                        duplicatePlayer.play()
                    }
                } else {
                    do{
                        let player = try AVAudioPlayer(contentsOf: url)
                        soundEffects[url] = player
                        player.prepareToPlay()
                        player.play()
                    } catch {
                        print("Unable to play sound effect: \(error)")
                    }
                }
            }
        } else {
            print("Unable find sound effect: \(sound)")
        }
    }
    
    // MARK: - AVAudioPlayerDelegate

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = spareSoundEffects.firstIndex(of: player) {
            spareSoundEffects.remove(at: index)
        }
    }
}

extension SoundManager {
    func playMove() {
        playSoundEffect(sound: "move.mp3")
    }
    func playMoveWin() {
        playSoundEffect(sound: "moveWin.mp3")
    }
    func playMoveLose() {
        playSoundEffect(sound: "moveLose.mp3")
    }
    func playVictory() {
        playSoundEffect(sound: "victory.mp3")
    }
    func playDefeat() {
        playSoundEffect(sound: "defeat.mp3")
    }
    func playTheme() {
        playBackgroundSound(sound: "theme.mp3")
    }
}

