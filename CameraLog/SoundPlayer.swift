//
//  SoundPlayer.swift
//  CameraLog
//
//  Created by Ryan Crabb on 5/5/22.
//  Copyright © 2022 Smith-Kettlewell Eye Research Institute. All rights reserved.
//

import Foundation
import AVFoundation

class SoundPlayer{
    var player = AVAudioPlayer()
    var isPlaying = false
    var dingSoundFileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "noquery", ofType: "wav")!)
    var buzzSoundFileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "query", ofType: "wav")!)
    var recordingSoundFileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Recording", ofType: "m4a")!)
    var stoppedSoundFileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Stopped", ofType: "m4a")!)
    
    
    func playBuzz(){
        if self.isPlaying {
            return
        }
        do {
            //self.isPlaying = true
            self.player = try AVAudioPlayer(contentsOf: buzzSoundFileURL)
            self.player.numberOfLoops = 0
            self.player.play()
            //self.isPlaying = false
        } catch { print("Sound Error")}
    }
    
    func playDing(){
        if self.isPlaying {
            return
        }
        do {
            //self.isPlaying = true
            self.player = try AVAudioPlayer(contentsOf: dingSoundFileURL)
            self.player.numberOfLoops = 0
            self.player.play()
            //self.isPlaying = false
        } catch { print("Sound Error")}
    }
    
    func playRecording(){
        if self.isPlaying {
            return
        }
        do {
            self.player = try AVAudioPlayer(contentsOf: recordingSoundFileURL)
            self.player.numberOfLoops = 0
            self.player.play()
        } catch { print("Sound Error")}
    }
    
    
    
    func playStopped(){
        if self.isPlaying {
            return
        }
        do {
            self.player = try AVAudioPlayer(contentsOf: stoppedSoundFileURL)
            self.player.numberOfLoops = 0
            self.player.play()
        } catch { print("Sound Error")}
    }
    
}
