//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let eggTimes = [
        "Soft": 5,
        "Medium": 7,
        "Hard": 12
    ]
    
    var countdownTimer: Timer!
    var secondsPassed: Int? = 0
    var totalTime: Int?
    
    var player: AVAudioPlayer?

    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)


            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var progressBarView: UIProgressView!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        let currentTitle = sender.currentTitle!
        
        print("hardess selected: \(currentTitle)")
        
        print("the timer is: \(eggTimes[currentTitle]!)")
        progressBarView.progress = 0.0
        mainTitle.text = currentTitle
        secondsPassed = 0
        
        if countdownTimer != nil {
            endTimer()
        }
        totalTime = eggTimes[currentTitle]!
        startTimer()
    }
    
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        print("\(timeFormatted(secondsPassed!))")
        
        if secondsPassed != totalTime {
            secondsPassed! += 1
            progressBarView.progress = Float(secondsPassed!) / Float(totalTime!)
        } else {
            endTimer()
            playSound()
            mainTitle.text = "Done!"
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

