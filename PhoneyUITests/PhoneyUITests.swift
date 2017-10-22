//
//  PhoneyUITests.swift
//  PhoneyUITests
//
//  Created by Steve Baker on 10/11/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import XCTest
import CallKit


class PhoneyUITests: XCTestCase {

    var token: NSObjectProtocol?

    //https://jeremywsherman.com/blog/2016/03/19/xctestexpectation-gotchas/#kaboom-calling-twice
    weak var expectCallHasConnected: XCTestExpectation?
    weak var expectCallHasEnded: XCTestExpectation?

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.

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
        self.expectCallHasConnected = self.expectation(description: "expect call hasConnected")
        self.expectCallHasEnded = self.expectation(description: "expect call hasEnded")

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
}

extension PhoneyUITests: CXCallObserverDelegate {

    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        // This callback comes from iOS.
        // It accurately represents that a phone call connected or ended.

        if call.isOutgoing && call.hasConnected && !call.hasEnded {
            print("outgoing call hasConnected")
            if self.expectCallHasConnected != nil {
                self.expectCallHasConnected?.fulfill()
                // set nil to avoid error from calling multiple times
                // https://jeremywsherman.com/blog/2016/03/19/xctestexpectation-gotchas/#kaboom-calling-twice
                self.expectCallHasConnected = nil
            }
        }
        if call.isOutgoing && call.hasEnded {
            print("outgoing call hasEnded")
            if self.expectCallHasEnded != nil {
                self.expectCallHasEnded?.fulfill()
                // set nil to avoid error from calling multiple times
                self.expectCallHasEnded = nil
            }
        }
    }
}


