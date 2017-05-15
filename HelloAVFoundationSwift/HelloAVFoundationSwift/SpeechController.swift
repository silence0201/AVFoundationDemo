//
//  SpeechController.swift
//  HelloAVFoundationSwift
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechController: NSObject {
    let synthesizer = AVSpeechSynthesizer()
    var speechStrings: [String] {
        return ["Hello AV Foundation. How are you?",
                "I'm well! Thanks for asking.",
                "Are you excited about the book?",
                "Very! I have always felt so misunderstood.",
                "What's your favorite feature?",
                "Oh, they're all my babies.  I couldn't possibly choose.",
                "It was great to speak with you!",
                "The pleasure was all mine!  Have fun!"]
    }
    var voices: [AVSpeechSynthesisVoice] {
        return [AVSpeechSynthesisVoice.init(language: "en-US")!,
                AVSpeechSynthesisVoice.init(language: "en_GB")!]
    }
    
    func beginConversation() {
        for (index,string) in speechStrings.enumerated() {
            let utterance = AVSpeechUtterance.init(string: string)
            utterance.voice = voices[index % 2]
            utterance.rate = 0.5
            utterance.pitchMultiplier = 0.8
            utterance.postUtteranceDelay = 0.1
            synthesizer .speak(utterance)
        }
    }
}
