//
//  PhoneyUITests.swift
//  PhoneyUITests
//
//  Created by Steve Baker on 10/11/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import XCTest


class PhoneyUITests: XCTestCase {

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

    /// handle system alert shown by iOS
    /// https://stackoverflow.com/questions/39973904/handler-of-adduiinterruptionmonitor-is-not-called-for-alert-related-to-photos/39976352#39976352
    /// http://masilotti.com/ui-testing-cheat-sheet/
    private func acceptPermissionAlert(expectation: XCTestExpectation) -> NSObjectProtocol {

        let token = addUIInterruptionMonitor(withDescription: "call alert") { alert -> Bool in

            if alert.buttons["Call"].exists {
                self.alertCallButton = alert.buttons["Call"]
                alert.buttons["Call"].tap()
                print("*** tapped alert Call")

                self.endCall(expectation: expectation)
                // indicate handler did handle the alert
                return true
            }
            // indicate handler did not handle the alert
            return false
        }
        return token
    }

    /// make a web request to a service to end the phone call
    func endCall(expectation: XCTestExpectation) {

        // https://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method#26365148
        let urlString = "http://10.0.0.4:5000/api/v1/gpio/end-phone-call/"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data, error == nil else {
                // fundamental networking error
                print("error=\(String(describing: error))")
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // http error
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }

            // got response from web server
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            // responseString = Optional("{\n  \"error\": null,\n  \"new_value\": 0,\n  \"pin_direction\": \"output\",\n  \"pin_name\": \"OUT_24\",\n  \"pin_number\": \"24\",\n  \"status\": \"SUCCESS\"\n}")

            // TODO: consider parse json, add conditional if SUCCESS

            expectation.fulfill()
        }
        task.resume()
    }

    func testCallTapped() {

        // don't specify bundle id
        // let app = XCUIApplication()
        let app = XCUIApplication(bundleIdentifier: "com.beepscore.Phoney")
        //print("app.debugDescription:\n \(app.debugDescription)")

        let appCallButton = app.buttons["Call Now"]
        if appCallButton.waitForExistence(timeout: 10) {

            // this syntax resulted in an error message
            // "NSInternalInconsistencyException", "API violation - call made to wait without any expectations having been set."
            // let expectation = XCTestExpectation(description: "expect call ended")
            // instead instantiate via self.expectation
            // https://stackoverflow.com/questions/41145269/api-violation-when-using-waitforexpectations
            let expectation = self.expectation(description: "expect call ended")

            let token = acceptPermissionAlert(expectation: expectation)

            appCallButton.tap()
            print("*** tapped appCallButton")

            // interact with app to cause system alert handler to fire
            // https://stackoverflow.com/questions/32148965/xcode-7-ui-testing-how-to-dismiss-a-series-of-system-alerts-in-code?rq=1
            // avoid potential error
            // "Application for Target Application 0x1c40af060 is not foreground."
            // I think this still fails sometimes due to race condition
            if app.state == .runningForeground {
                app.swipeUp()
                print("*** swiped up")
            }

            waitForExpectations(timeout: 20) { (error) in
                if let error = error {
                    XCTFail("expectation timed out with error: \(error)")
                }
            }

        }
    }

}


