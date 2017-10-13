//
//  ViewController.swift
//  Phoney
//
//  Created by Steve Baker on 10/11/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var callButton: UIButton!
    let phoneNumber = "555-1212"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.callButton.setTitle("call \(phoneNumber)", for: .normal)
        //setTorchMaximum()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setTorchMaximum() {
        // turn light on- this can illuminate a photodetector,
        // close switch connected to headphone jack and end call
        // this is a "mostly hardware" solution
        var device: AVCaptureDevice!
        device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
        device.setTorchMaximum()
    }

    /// on device, when user taps button, iOS shows an alert with "Cancel" and "Call"
    /// tapping call dismisses alert, navigates to phone app, makes call
    @IBAction func callTapped(_ sender: Any) {
        print("callTapped")

        // https://stackoverflow.com/questions/27259824/calling-a-phone-number-in-swift
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
}

