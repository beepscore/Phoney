# Purpose
Phoney is an iOS application to experiment with testing phone calls.

# References

## pi_gpio_service
Make a simple Python flask web service to read and write Raspberry Pi GPIO.  
https://github.com/beepscore/pi_gpio_service

## Use Switch Control to navigate your iPhone, iPad, or iPod touch
https://support.apple.com/en-us/HT201370

# Results

## Background
Making a phone call requires running on device, not simulator.
### start call
XCUITest can programmatically enter a phone number and start a phone call.
### end call
We want to programmatically end a phone call.
Xcode recorder can record tapping the red end call button.
However, playing the recorded code doesn't work, the test never "sees" the red button.
I think Apple or carrier may be restricting info/access to a call in progress.

## CXCallObserver
- Advantages: doesn't require any additional hardware.
- Disadvantages:

    I think CXCallObserver, CXCallProvider are designed for VOIP apps, not for apps that navigate to phone app.
    I used CXCallObserver delegate methods to detect call status.
    I tried using CXCallProvider to end call, but it didn't work, maybe because the call was not started by a VOIP app.
    I deleted this code.

For more info see appendix.

## headphone jack switch
- Advantages: Can programmatically end a phone call. probably easiest to set up.
- Disadvantage: on iOS clicking switch only works for a few actions, requires some hardware,

XCUITest runs on iOS, Swift for iOS can't easily issue a system call or spawn a process.
XCUITest can make a web request to a server, ask it to close switch.

Server can run on the same mac running Xcode, or on a Raspberry Pi or Arduino.
Plug programmatically controlled switch into iOS device microphone jack.

Closing (and opening?) the switch will end the phone call and leave the view with the red end call button.
The phone will navigate to the mobilephone application view with the green start call button.
Then XCUITest can call application terminate to get back to initial Phoney app?

### TODO:
what is the easiest way to sync between XCUITest and hardware? Just go slow?
Does test need to confirm the phone call was answered? Probably, so what is easiest way to do this?
Could restore CXCallObserver method and check call status.
Or Siri could listen for certain words, or a machine could programmatically say some words (via "say" text to speech or mp3).

## Accessibility Switch Control
- Advantages: more flexible, can control anything on phone UI.
- Disadvantage: more complicated to set up

Ideas:
Turn on Switch Control, set it to work with either custom gestures or raspberry pi that mimics external bluetooth keyboard.
### screen switch
seems very limited, only one switch.

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

#### Adafruit Feather nRF52 Bluefruit LE - nRF52832
PRODUCT ID: 3406
$24.95
https://www.adafruit.com/product/3406

# Appendix - setup

Go to Settings > General > Accessibility > Switch Control.
Tap Scanning Style, then select Manual Scanning.

Set up a switch to perform the tap gesture at Settings > General > Accessibility > Switch Control > Switches.

# Appendix CXCallObserver

## How to detect call incoming programmatically
https://stackoverflow.com/questions/23535355/how-to-detect-call-incoming-programmatically/24930697#24930697

## CXCallObserver
https://developer.apple.com/documentation/callkit/cxcallobserver

## CTCallCenter
deprecated
https://developer.apple.com/documentation/coretelephony/ctcallcenter
https://developer.apple.com/documentation/coretelephony/ctcall

