# Purpose
Phoney is an iOS application to experiment with testing phone calls.

# References

## Use Switch Control to navigate your iPhone, iPad, or iPod touch
https://support.apple.com/en-us/HT201370

## How to detect call incoming programmatically
https://stackoverflow.com/questions/23535355/how-to-detect-call-incoming-programmatically/24930697#24930697

## CXCallObserver
https://developer.apple.com/documentation/callkit/cxcallobserver

## CTCallCenter
https://developer.apple.com/documentation/coretelephony/ctcallcenter
https://developer.apple.com/documentation/coretelephony/ctcall

# Results

## CXCallObserver
I think CXCallObserver, CXCallProvider are for VOIP apps, not for apps that navigate to phone app.

## Accessibility Switch Control
Ideas:
Turn on Switch Control, set it to work with either custom gestures or raspberry pi that mimics external bluetooth keyboard.
### custom gesture
Set one gesture to advance, one to select.
This has big advantage can generate gesture within XCUITest.
### bluetooth keyboard
https://www.youtube.com/watch?v=qDOVPdX9BE0


## switch
Ideas:
Plug microphone or remote control switch into phone microphone jack.
Write macos program to close a switch. Could use an arduino.
In XCUITest, issue macos system call to close the switch.
This will end the phone call and leave the view with the red end call button.
The phone will navigate to the phone application view with the green start call button.
Then XCUITest can call application terminate to get back to initial Phoney app?

