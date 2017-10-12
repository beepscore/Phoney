//
//  ViewController.swift
//  Phoney
//
//  Created by Steve Baker on 10/11/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var callButton: UIButton!
    let phoneNumber = "555-1212"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.callButton.setTitle("call \(phoneNumber)", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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

