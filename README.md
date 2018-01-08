# Purpose
Phoney is an iOS application to experiment with testing phone calls.

# Results

## Background
Making a phone call requires running on device, not simulator.

### start call
XCUITest can programmatically enter a phone number and start a phone call.
Then use springboard app to handle alert tap "Call".
### end call
Use springboard app to tap "End call" button.

## Other approaches to end call
Before I found simple solution via springboard app, I thought of and tried some other approaches.

### CXCallObserver
The test uses CXCallObserver delegate method callObserver(_ callObserver: callChanged:)
The test can verify that a call hasConnected or hasEnded.
But it's only an observer, doesn't have a method to end a call.

### Headphone breakout switch
I prototyped test that uses addUIInterruptionMonitor and makes request to a raspberry pi web service end the call.
The raspberry pi connects to a relay and a headphone breakout switch.
The relay momentarily shorts the microphone and common contacts.
This ended the call, but test kept failing with error "Application for Target Application 0x1c40af060 is not foreground."

### Accessibility Switch Control
This approach is very general, could be applied to many actions.
I may prototype it later.
For more info see Using a Raspberry Pi for iPhone Switch Control
http://beepscore.com/using-raspberry-pi-for-iphone-switch-control/index.html

# References

## XCUITest an iOS app phone call
http://beepscore.com/xcuitest-ios-app-phone-call/index.html

## Using a Raspberry Pi to end an iPhone phone call
http://beepscore.com/using-raspberry-pi-to-end-iphone-phone-call/

## Using a Raspberry Pi for iPhone Switch Control
http://beepscore.com/using-raspberry-pi-for-iphone-switch-control/index.html

## XCUITest phone call with help from springboard
https://stackoverflow.com/questions/46322758/call-button-on-ui-testing

## How to detect call incoming programmatically
https://stackoverflow.com/questions/23535355/how-to-detect-call-incoming-programmatically/24930697#24930697

## CXCallObserver
https://developer.apple.com/documentation/callkit/cxcallobserver

## CTCallCenter
deprecated
https://developer.apple.com/documentation/coretelephony/ctcallcenter
https://developer.apple.com/documentation/coretelephony/ctcall

# Appendix Run tests on device
Note UITests won't run on simulator. This is expected.
UITests require device with phone hardware to find and tap springboard phone call buttons.

## 2018-01-07
To run unit UITests only (not unit tests), select scheme PhoneyUITests and type command-u.
To run unit unit tests only (not UI tests), select scheme PhoneyTests and type command-u.
