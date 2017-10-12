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

    ////////////////

    // https://github.com/joemasilotti/JAMTestHelper/blob/master/JAM%20Test%20Helper/JAMTestHelper.swift

    /**
    * Waits for the default timeout until `element.exists` is true.
    *
    * @param element the element you are waiting for
    * @see waitForElementToNotExist()
    */
    func waitForElementToExist(_ element: XCUIElement) {
        waitForElement(element, toExist: true)
    }

    /**
    * Waits for the default timeout until `element.exists` is false.
    *
    * @param element the element you are waiting for
    * @see waitForElementToExist()
    */
    func waitForElementToNotExist(_ element: XCUIElement) {
        waitForElement(element, toExist: false)
    }

    private func waitForElement(_ element: XCUIElement, toExist: Bool) {
        let expression = { () -> Bool in
            return element.exists == toExist
        }
        waitFor(expression: expression, failureMessage: "Timed out waiting for element to exist.")
    }


    private func waitFor(expression: () -> Bool, failureMessage: String) {
        let startTime = Date.timeIntervalSinceReferenceDate

        while (!expression()) {
            if (NSDate.timeIntervalSinceReferenceDate - startTime > 20.0) {
                raiseTimeOutException(message: failureMessage)
            }
            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 0.1, Bool(truncating: 0))
        }
    }

    private func raiseTimeOutException(message: String) {
        NSException(name: NSExceptionName(rawValue: "JAMTestHelper Timeout Failure"), reason: message, userInfo: nil).raise()
    }

    ////////////////

    func testCallTapped() {

        // don't specify bundle id
        var app = XCUIApplication()
        //print("app.debugDescription:\n \(app.debugDescription)")

        let appCallButton = app.buttons["call 555-1212"]
        if appCallButton.waitForExistence(timeout: 5) {
            appCallButton.tap()
            print("*** tapped app call 555-1212")

            acceptPermissionAlert()

            // interact with app to cause system alert handler to fire
            // https://stackoverflow.com/questions/32148965/xcode-7-ui-testing-how-to-dismiss-a-series-of-system-alerts-in-code?rq=1
            // avoid potential error
            // "Application for Target Application 0x1c40af060 is not foreground."
            if app.state == .runningForeground {
                app.swipeUp()
            }

            let _ = app.wait(for: .runningBackground, timeout: 10)
            app.swipeUp()
            waitForElementToNotExist(alertCallButton!)

            //app = XCUIApplication()
            print("app.debugDescription:\n \(app.debugDescription)")

            let endCallButton = app.buttons["End call"]
            if endCallButton.waitForExistence(timeout: 40) {
                endCallButton.tap()
                print("*** tapped endCallButton")
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

    func xxxtestPhoneApp() {

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

