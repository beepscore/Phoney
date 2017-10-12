# Purpose
Phoney is an iOS application to experiment with testing phone calls.

# References

## How to detect call incoming programmatically
https://stackoverflow.com/questions/23535355/how-to-detect-call-incoming-programmatically/24930697#24930697

## CXCallObserver
https://developer.apple.com/documentation/callkit/cxcallobserver

## CTCallCenter
https://developer.apple.com/documentation/coretelephony/ctcallcenter
https://developer.apple.com/documentation/coretelephony/ctcall

# Results

## CXCallObserver
CTCallCenter is deprecated in iOS 9.

## Accessibility Switch Control
might be able to use this

## switch
Idea:
Plug microphone or remote control switch into phone microphone jack.
Write macos program to close a switch. Could use an arduino.
In XCUITest, issue macos system call to close the switch.
This will end the phone call and leave the view with the red end call button.
The phone will navigate to the phone application view with the green start call button.
Then XCUITest can call application terminate to get back to initial Phoney app?

