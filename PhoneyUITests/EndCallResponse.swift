//
//  EndCallResponse.swift
//  PhoneyUITests
//
//  Created by Steve Baker on 10/15/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import Foundation

// https://developer.apple.com/documentation/swift/codable
// example response from service.py for gpio
// EndCallResponseData(error: nil, new_value: 0,
// pin_direction: "output", pin_name: "OUT_24", pin_number: "24", status: "SUCCESS")
// struct EndCallResponse: Codable {
//     var error: String?
//     var new_value: Int
//     var pin_direction: String
//     var pin_name: String
//     var pin_number: String
//     var status: String
// }

// example response data from service_piface.py for piface relay
struct EndCallResponse: Codable {
    var api_name: String
    var response: String
    var status: String
    var version: String
}
