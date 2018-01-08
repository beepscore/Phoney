//
//  PhoneyUITests.swift
//  PhoneyUITests
//
//  Created by Steve Baker on 10/11/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import XCTest
import CallKit
// AVFoundation for text to speech
import AVFoundation


class PhoneyUITests: XCTestCase {

    //https://jeremywsherman.com/blog/2016/03/19/xctestexpectation-gotchas/#kaboom-calling-twice
    // make expectations properties so that delegate methods can reference them
    weak var expectCallHasConnected: XCTestExpectation?
    weak var expectCallHasEnded: XCTestExpectation?
    weak var expectSpeak: XCTestExpectation?

    // making synthesizer a property fixed AVSpeechSynthesizerDelegate callbacks weren't getting called
    // https://stackoverflow.com/questions/24093434/avspeechsynthesizer-works-on-simulator-but-not-on-device?rq=1
    var synthesizer: AVSpeechSynthesizer?

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.

        synthesizer = AVSpeechSynthesizer()
        synthesizer?.delegate = self
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

        super.tearDown()
    }

    func testCallTapped() {

        // this statement resulted in an error message
        // "NSInternalInconsistencyException", "API violation - call made to wait without any expectations having been set."
        // let expectation = XCTestExpectation(description: "expect something")
        // instead instantiate via self.expectation
        // https://stackoverflow.com/questions/41145269/api-violation-when-using-waitforexpectations
        expectCallHasConnected = self.expectation(description: "expect call hasConnected")
        expectCallHasEnded = self.expectation(description: "expect call hasEnded")

        let callObserver = CXCallObserver()
        callObserver.setDelegate(self, queue: nil)

        // don't specify bundle id
        let app = XCUIApplication()
        //let app = XCUIApplication(bundleIdentifier: "com.beepscore.Phoney")
        //print("app.debugDescription:\n \(app.debugDescription)")

        // springboard app handles phone call alert
        // https://stackoverflow.com/questions/46322758/call-button-on-ui-testing
        // Previously I tried to handle this via addUIInterruptionMonitor.
        // After adding monitor, tapped in app to activate alert.
        // Test kept failing with error "Application for Target Application 0x1c40af060 is not foreground."
        let springboardApp = XCUIApplication(bundleIdentifier: "com.apple.springboard")

        app.launch()

        let appCallButton = app.buttons["Call Now"]
        if appCallButton.waitForExistence(timeout: 10) {

            appCallButton.tap()
            print("*** tapped appCallButton")

            springboardApp.buttons["Call"].tap()

            let delayBeforeEndCallSeconds: UInt32 = 12
            sleep(delayBeforeEndCallSeconds)

            springboardApp.buttons["End call"].tap()

            waitForExpectations(timeout: 10) { (error) in
                if let error = error {
                    XCTFail("expectation timed out with error: \(error)")
                }
            }
        }
    }

    /// testSpeak passes on simulator and on device.
    /// But on device I can't hear anything!
    func testSpeak() {
        expectSpeak = self.expectation(description: "expect speak")
        speak("other option")

        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("expectation timed out with error: \(error)")
            }
        }
    }

    /// currently works on simulator but not on device
    /// I think the problem is due to the test running in background.
    /// May need to configure audio session to play in background and set plist
    /// phone sound switch must be on, to avoid error
    /// TTSPlaybackCreate unable to initialize dynamics: -3000
    /// Failure starting audio queue alp!
    /// https://forums.developer.apple.com/thread/87691
    func speak(_ string: String) {

        // for use if switching between voice synthesis and voice recognition
        // https://forums.developer.apple.com/thread/88030
        // https://stackoverflow.com/questions/40639660/swift-3-using-speech-recognition-and-avfoundation-together
        // https://stackoverflow.com/questions/40270738/avspeechsynthesizer-does-not-speak-after-using-sfspeechrecognizer/43098873#43098873
        //   let audioSession = AVAudioSession.sharedInstance()
        //   do {
        //       try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        //       try audioSession.setActive(false, with: .notifyOthersOnDeactivation)
        //   } catch {
        //       print("failed")
        //   }

        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer?.speak(utterance)
    }

    /// this works on simulator and device
    func testSpeakTapped() {
        let app = XCUIApplication()
        app.launch()

        let appSpeakButton = app.buttons["speak"]
        if appSpeakButton.waitForExistence(timeout: 10) {
            appSpeakButton.tap()
            print("*** tapped appSpeakButton")
            // wait for speech in Phoney.app to finish
            sleep(4)
        }
    }
}

extension PhoneyUITests: CXCallObserverDelegate {

    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        // This callback comes from iOS.
        // It accurately represents that a phone call connected or ended.

        if call.isOutgoing && call.hasConnected && !call.hasEnded {
            print("outgoing call hasConnected")
            if expectCallHasConnected != nil {
                expectCallHasConnected?.fulfill()
                // set nil to avoid error from calling multiple times
                // https://jeremywsherman.com/blog/2016/03/19/xctestexpectation-gotchas/#kaboom-calling-twice
                expectCallHasConnected = nil
            }
        }
        if call.isOutgoing && call.hasEnded {
            print("outgoing call hasEnded")
            if self.expectCallHasEnded != nil {
                expectCallHasEnded?.fulfill()
                // set nil to avoid error from calling multiple times
                expectCallHasEnded = nil
            }
        }
    }
}

extension PhoneyUITests: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("didStart utterance")
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish utterance")
        if expectSpeak != nil {
            expectSpeak?.fulfill()
            // set nil to avoid error from calling multiple times
            expectSpeak = nil
        }
    }
}
