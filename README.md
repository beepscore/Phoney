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
### screen switch
seems very limited, only one switch.

This has big advantage can generate gesture within XCUITest.
### custom gesture
Set one gesture to advance, one to select.

### BLE keyboard emulator and wireless service
On iOS device enable switch control from external bluetooth keyboad.
Pair iOS device with hardware (Raspberry Pi?) acting as a BLE keyboard emulator and as a web service.
XCUITest could call the web service to end phone call.
Service could respond by sending emulated keystrokes to select and tap red end call button.

#### iOS Switch Control on a Budget using Bluetooth Keyboards
https://www.youtube.com/watch?v=qDOVPdX9BE0

#### Raspberry Pi keyboard emulator
https://impythonist.wordpress.com/2014/02/01/emulate-a-bluetooth-keyboard-with-the-raspberry-pi/
code not working in Raspbian Jessie?

#### HIDKeyboard
https://learn.adafruit.com/introducing-the-adafruit-bluefruit-spi-breakout/hidkeyboard

#### Bluefruit EZ-Key - 12 Input Bluetooth HID Keyboard Controller - v1.2
PRODUCT ID: 1535
$19.95
https://www.adafruit.com/product/1535
Note: This product is currently undergoing a revision and will be available again soon!

## switch
Ideas:
Plug microphone or remote control switch into phone microphone jack.
Write macos program to close a switch. Could use an arduino.
In XCUITest, issue macos system call to close the switch.
This will end the phone call and leave the view with the red end call button.
The phone will navigate to the phone application view with the green start call button.
Disadvantage: very limited, only works for a few actions.
Then XCUITest can call application terminate to get back to initial Phoney app?


## Appendix - setup

Go to Settings > General > Accessibility > Switch Control.
Tap Scanning Style, then select Manual Scanning.

Set up a switch to perform the tap gesture at Settings > General > Accessibility > Switch Control > Switches.

