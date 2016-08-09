//
// Created by Richard Martinez on 8/8/16.
// Copyright (c) 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

@objc protocol AudioManagerDelegate {
    optional func didStartRecording()
    optional func didFinishRecording()
    optional func didStartSpeaking()
    optional func didFinishSpeaking()
}


/// Handles All of the Necessary Setup for Text-to-Speech synthesis
/// Responds to all AVSpeechSynthesizerDelegate methods
class AudioManager: NSObject {

    weak var delegate: AudioManagerDelegate?

    /// State Machine
    let audioStatus: AudioStatus = .stopped

    private var textQueue = [String]()
    var updateTimer: CADisplayLink!

    private let synthesizer = AVSpeechSynthesizer()
    var speechTimer: CGFloat = 0.0

    func addToQueue(text: String) {
        if !text.isEmpty {
            textQueue.append(text)
        }
    }

    /// `timerUpdates:` executes a provided block in the current run loop in order to receive record and playback timer updates.
    /// - Parameter: onMainThread is a flag telling AudioManager whether to run the given block on the main thread (i.e. for UI updates)
    /// - Parameter: withBlock a block that takes no params and returns void to be executed
    func timerUpdates(onMainThread mainThread: Bool, withBlock block: () -> ()) {
        if mainThread {
            // TODO: Execute this in the CADisplayLink update loop
            dispatch_async(dispatch_get_main_queue(), block)
        } else {

        }
    }

    func startSpeaking ()  {
        
    }

}

extension AudioManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
    }

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
    }

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didPauseSpeechUtterance utterance: AVSpeechUtterance) {
    }

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didContinueSpeechUtterance utterance: AVSpeechUtterance) {
    }

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didCancelSpeechUtterance utterance: AVSpeechUtterance) {
    }

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
    }

}