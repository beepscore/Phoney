//
//  ViewController.swift
//  Phoney
//
//  Created by Steve Baker on 10/11/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Don't use. ATT may charge if you connect and then get a phone number from them
    // let phoneNumber = "555-1212"
    let wellsFargoPhoneNumber = "800-869-3557"

    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        phoneNumberLabel.text = "Wells Fargo \(wellsFargoPhoneNumber)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// on device, when user taps button, iOS shows an alert with "Cancel" and "Call"
    /// tapping call dismisses alert, navigates to phone app, makes call
    @IBAction func callTapped(_ sender: Any) {
        // https://stackoverflow.com/questions/27259824/calling-a-phone-number-in-swift
        if let phoneCallURL = URL(string: "tel://\(wellsFargoPhoneNumber)") {
            UIApplication.shared.open(phoneCallURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
