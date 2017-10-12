//
//  PhoneyUITests.swift
//  PhoneyUITests
//
//  Created by Steve Baker on 10/11/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import XCTest
// import CallKit for CXCall
import CallKit

class PhoneyUITests: XCTestCase {

    let app = XCUIApplication(bundleIdentifier: "com.beepscore.Phoney")

    let expectation = XCTestExpectation(description: "expect call ended")

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

    func xxxxxxxxxtestCallTapped() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let appCallButton = app.buttons["call 555-1212"]
        if appCallButton.waitForExistence(timeout: 5) {
            appCallButton.tap()
            print("*** tapped app call 555-1212")

            // recorded this, but when running in test it threw error
            // https://stackoverflow.com/questions/40403805/dismissing-alert-xcuitest
            // app.alerts["555-1212"].buttons["Call"].tap()

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

    func testPhoneApp() {

        let callObserver = CXCallObserver()
        callObserver.setDelegate(self, queue: nil)

        let provider = CXProvider(configuration: type(of: self).providerConfiguration)
        provider.setDelegate(self, queue: nil)

        let phoneApp = XCUIApplication(bundleIdentifier: "com.apple.mobilephone")
        phoneApp.launch()

        callPhoneNumber(app: phoneApp, phoneNumberString: "8008693557")

        wait(for: [expectation], timeout: 40)
    }

}

extension PhoneyUITests: CXCallObserverDelegate {

    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {

        print("isOutgoing:  \(call.isOutgoing)")
        print("hasConnected:  \(call.hasConnected)")
        print("hasEnded: \(call.hasEnded)")

        if call.hasConnected {

            let endCallAction = CXEndCallAction(call: call.uuid)
            let callTransaction = CXTransaction(action: endCallAction)

            let callController = CXCallController()
            callController.request(callTransaction) { error in
                print("*** callController requested end call")
                if error != nil {
                    print("*** error \(error.debugDescription)")
                    // *** error Optional(Error Domain=com.apple.CallKit.error.requesttransaction Code=1 "(null)")
                    // try to fix by setting info.plist app provides voice over ip services
                    // https://stackoverflow.com/questions/44534002/what-could-be-cause-for-cxerrorcoderequesttransactionerrorunentitled-error-in-ca
                }
            }

            //let phoneApp = XCUIApplication(bundleIdentifier: "com.apple.mobilephone")
            //let app = XCUIApplication()

            //app.terminate()

        }
    }
}

extension PhoneyUITests: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        // do nothing
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {

        print("hi from provider perform action!")
        self.expectation.fulfill()
        action.fulfill()
    }

}

