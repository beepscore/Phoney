//
//  PhoneyUITests.swift
//  PhoneyUITests
//
//  Created by Steve Baker on 10/11/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import XCTest

class PhoneyUITests: XCTestCase {

    let app = XCUIApplication()
    // https://stackoverflow.com/questions/9910366/what-is-the-bundle-identifier-of-apples-default-applications-in-ios
    let phoneApp = XCUIApplication(bundleIdentifier: "com.apple.mobilephone")

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

    func testCallTapped() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        // handle system alert shown by iOS
        // http://masilotti.com/ui-testing-cheat-sheet/
        addUIInterruptionMonitor(withDescription: "555-1212") { (alert) -> Bool in
            alert.buttons["Call"].tap()
            print("*** tapped alert Call")
            return true
        }

        let appCallButton = app.buttons["call 555-1212"]
        if appCallButton.waitForExistence(timeout: 5) {
            appCallButton.tap()
            print("*** tapped app call 555-1212")

            // recorded this, but when running in test it threw error
            // https://stackoverflow.com/questions/40403805/dismissing-alert-xcuitest
            // app.alerts["‭555-1212‬"].buttons["Call"].tap()

            // interact with app to cause system alert handler to fire
            // https://stackoverflow.com/questions/32148965/xcode-7-ui-testing-how-to-dismiss-a-series-of-system-alerts-in-code?rq=1
            app.tap()


            let endCallButton = phoneApp.buttons["End call"]
            // https://dzone.com/articles/new-xcuitest-features-with-xcode-9-hands-on-explor
            if endCallButton.waitForExistence(timeout: 20) {
                endCallButton.tap()
                print("*** tapped endCallButton")
            }

        }



        // https://stackoverflow.com/questions/28821722/delaying-function-in-swift
//        let nowPlusDelay = DispatchTime.now() + .seconds(20)
//        DispatchQueue.main.asyncAfter(deadline: nowPlusDelay, execute: {
//            // in Phone app, tap red circular button to end call
//            app.buttons["End call"].tap()
//        })
    }
    
}
