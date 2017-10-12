//
//  PhoneyUITests.swift
//  PhoneyUITests
//
//  Created by Steve Baker on 10/11/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import XCTest


class PhoneyUITests: XCTestCase {

    let expectation = XCTestExpectation(description: "expect call ended")
    var alertCallButton: XCUIElement?

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // handle system alert shown by iOS
    // https://stackoverflow.com/questions/39973904/handler-of-adduiinterruptionmonitor-is-not-called-for-alert-related-to-photos/39976352#39976352
    // http://masilotti.com/ui-testing-cheat-sheet/
    private func acceptPermissionAlert() {

        let _ = addUIInterruptionMonitor(withDescription: "call alert") { alert -> Bool in

            if alert.buttons["Call"].exists {
                self.alertCallButton = alert.buttons["Call"]
                alert.buttons["Call"].tap()
                print("*** tapped alert Call")
                return true
            }
            return false
        }
    }

    func testCallTapped() {

        // don't specify bundle id
        let app = XCUIApplication()
        //print("app.debugDescription:\n \(app.debugDescription)")

        let appCallButton = app.buttons["call 555-1212"]
        if appCallButton.waitForExistence(timeout: 5) {
            appCallButton.tap()
            print("*** tapped app call 555-1212")

            acceptPermissionAlert()

            // interact with app to cause system alert handler to fire
            // https://stackoverflow.com/questions/32148965/xcode-7-ui-testing-how-to-dismiss-a-series-of-system-alerts-in-code?rq=1
            app.tap()
            print("app.debugDescription:\n \(app.debugDescription)")

//            let endCallButton = app.buttons["End call"]
//            if endCallButton.waitForExistence(timeout: 40) {
//                endCallButton.tap()
//                print("*** tapped endCallButton")
//            }

        }
    }

    static var providerConfiguration: CXProviderConfiguration {

        let providerConfiguration = CXProviderConfiguration(localizedName: "Hotline")

        providerConfiguration.supportsVideo = false
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]

        return providerConfiguration
    }

    func callPhoneNumber(app: XCUIApplication, phoneNumberString: String) {

        for digitCharacter in phoneNumberString {
            app.buttons[String(digitCharacter)].tap()
        }
        app.buttons["Call"].tap()
    }

}


