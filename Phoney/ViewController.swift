//
//  ViewController.swift
//  Phoney
//
//  Created by Steve Baker on 10/11/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import UIKit
// AVFoundation for text to speech
import AVFoundation

class ViewController: UIViewController {

    // making synthesizer a property fixed AVSpeechSynthesizerDelegate callbacks weren't getting called
    // https://stackoverflow.com/questions/24093434/avspeechsynthesizer-works-on-simulator-but-not-on-device?rq=1
    var synthesizer: AVSpeechSynthesizer?

    // Don't use. ATT may charge if you connect and then get a phone number from them
    // let phoneNumber = "555-1212"
    let wellsFargoPhoneNumber = "800-869-3557"

    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        phoneNumberLabel.text = "Wells Fargo \(wellsFargoPhoneNumber)"

        synthesizer = AVSpeechSynthesizer()
        synthesizer?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// on device, when user taps button, iOS shows an alert with "Cancel" and "Call"
    /// tapping call dismisses alert, navigates to phone app, makes call
    @IBAction func callTapped(_ sender: Any) {
        // https://stackoverflow.com/questions/27259824/calling-a-phone-number-in-swift
        if let phoneCallURL = URL(string: "tel://\(wellsFargoPhoneNumber)") {
            UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
    
    /// use for debugging XCUITest speaks on simulator but not on device
    @IBAction func speakTapped(_ sender: Any) {
        speak("other option")
    }

    func speak(_ string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer?.speak(utterance)
    }
}

extension ViewController: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("didStart utterance")
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish utterance")
    }
}
