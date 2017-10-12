//
//  PhoneyUITests.swift
//  PhoneyUITests
//
//  Created by Steve Baker on 10/11/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import XCTest

class PhoneyUITests: XCTestCase {
        
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

        // handle alert shown by iOS
        addUIInterruptionMonitor(withDescription: "555-1212") { (alert) -> Bool in
            alert.buttons["Call"].tap()
            return true
        }

        let app = XCUIApplication()
        app.buttons["call 555-1212"].tap()

        // recorded this, but when running in test it threw error
        // https://stackoverflow.com/questions/40403805/dismissing-alert-xcuitest
        // app.alerts["‭555-1212‬"].buttons["Call"].tap()

        // interact with app to cause handler to fire
        // https://stackoverflow.com/questions/32148965/xcode-7-ui-testing-how-to-dismiss-a-series-of-system-alerts-in-code?rq=1
        app.tap()

        // https://stackoverflow.com/questions/28821722/delaying-function-in-swift
//        let nowPlusDelay = DispatchTime.now() + .seconds(20)
//        DispatchQueue.main.asyncAfter(deadline: nowPlusDelay, execute: {
//            // in Phone app, tap red circular button to end call
//            app.buttons["End call"].tap()
//        })
    }
    
}
