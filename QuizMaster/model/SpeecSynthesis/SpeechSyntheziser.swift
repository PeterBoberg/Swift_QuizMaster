//
// Created by Kung Peter on 2017-04-18.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import AVFoundation

class SpeechSyntheziser: AVSpeechSynthesizer {

    func speak(sentence: String) {
        let utterance = AVSpeechUtterance(string: sentence)
        utterance.voice = AVSpeechSynthesisVoice(identifier: "en-AU")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        self.speak(utterance)
    }

    func stopImmediately(){
        self.stopSpeaking(at: .immediate)
    }

    func stopAtNextWord(){
        self.stopSpeaking(at: .word)
    }
}
