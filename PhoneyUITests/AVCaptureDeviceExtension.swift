//
//  AVCaptureDeviceExtension.swift
//  PhoneyUITests
//
//  Created by Steve Baker on 10/13/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//
// https://stackoverflow.com/questions/28999492/with-what-code-in-swift-do-you-turn-the-iphone-led-flash-on-off?noredirect=1&lq=1

import AVFoundation

extension AVCaptureDevice {

    var isLocked: Bool {
        do {
            try lockForConfiguration()
            return true
        } catch {
            print(error)
            return false
        }
    }

    func setTorch(intensity: Float) {
        guard hasTorch && isLocked else { return }
        defer { unlockForConfiguration() }
        if intensity > 0 {
            if torchMode == .off {
                torchMode = .on
            }
            do {
                try setTorchModeOn(level: intensity)
            } catch {
                print(error)
            }
        } else {
            torchMode = .off
        }
    }

    func setTorchMaximum() {
        setTorch(intensity: AVCaptureDevice.maxAvailableTorchLevel)
    }
}
