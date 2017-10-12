//
//  PhoneyUITests.swift
//  PhoneyUITests
//
//  Created by Steve Baker on 10/11/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import XCTest

class PhoneyUITests: XCTestCase {

    let app = XCUIApplication(bundleIdentifier: "com.beepscore.Phoney")

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
                alert.buttons["Call"].tap()
                print("*** tapped alert Call")
                return true
            }
            return false
        }
    }

    func testCallTapped() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let appCallButton = app.buttons["call 555-1212"]
        if appCallButton.waitForExistence(timeout: 5) {
            appCallButton.tap()
            print("*** tapped app call 555-1212")

            // recorded this, but when running in test it threw error
            // https://stackoverflow.com/questions/40403805/dismissing-alert-xcuitest
            // app.alerts["‭555-1212‬"].buttons["Call"].tap()

            acceptPermissionAlert()

            // interact with app to cause system alert handler to fire
            // https://stackoverflow.com/questions/32148965/xcode-7-ui-testing-how-to-dismiss-a-series-of-system-alerts-in-code?rq=1

            // avoid potential error
            // "Application for Target Application 0x1c40af060 is not foreground."
            if app.state == .runningForeground {
                app.swipeUp()
            }

            // https://stackoverflow.com/questions/9910366/what-is-the-bundle-identifier-of-apples-default-applications-in-ios
            // https://github.com/joeblau/apple-bundle-identifiers
            let phoneApp = XCUIApplication(bundleIdentifier: "com.apple.mobilephone")
            // https://dzone.com/articles/new-xcuitest-features-with-xcode-9-hands-on-explor
            if phoneApp.waitForExistence(timeout: 20) {

                print("phoneApp", phoneApp)
                print("phoneApp.buttons", phoneApp.buttons)
                let endCallButton = phoneApp.buttons["End call"]
                // https://dzone.com/articles/new-xcuitest-features-with-xcode-9-hands-on-explor
                if endCallButton.waitForExistence(timeout: 20) {
                    endCallButton.tap()
                    print("*** tapped endCallButton")
                }
            }
        }


        // https://stackoverflow.com/questions/28821722/delaying-function-in-swift
        //        let nowPlusDelay = DispatchTime.now() + .seconds(20)
        //        DispatchQueue.main.asyncAfter(deadline: nowPlusDelay, execute: {
        //            // in Phone app, tap red circular button to end call
        //            app.buttons["End call"].tap()
        //        })
    }
    
    func testPhoneApp() {

        let phoneApp = XCUIApplication(bundleIdentifier: "com.apple.mobilephone")
        phoneApp.launch()

        let button1 = phoneApp.buttons["1"]
        let button2 = phoneApp.buttons["2"]
        let button5 = phoneApp.buttons["5"]

        // call phone number
        button5.tap()
        button5.tap()
        button5.tap()
        button1.tap()
        button2.tap()
        button1.tap()
        button2.tap()

        phoneApp.buttons["Call"].tap()
        print("*** tapped Call button")
        XCUIDevice.shared.orientation = .faceUp

        print("phoneApp.buttons", phoneApp.buttons)
        // console shows
        //warning: could not execute support code to read Objective-C class data in the process. This may reduce the quality of type information available.
        // phoneApp.buttons <XCUIElementQuery: 0x1c0097f20>

        // test never finds end call button
        if phoneApp.buttons["End call"].waitForExistence(timeout: 20) {
            phoneApp.buttons["End call"].tap()
            print("*** tapped endCall button")
        }
    }

}
