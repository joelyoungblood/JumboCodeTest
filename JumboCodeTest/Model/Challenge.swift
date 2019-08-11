//
//  Challenge.swift
//  JumboCodeTest
//
//  Created by Joel Youngblood on 8/9/19.
//  Copyright © 2019 Joel Youngblood. All rights reserved.
//

import Foundation

struct Challenge: Codable {
    let payload: String
    let signature: String
    
    var decodedPayload: String? {
        guard let decodedData = Data(base64Encoded: payload) else { return nil }
        return String(data: decodedData, encoding: .utf8)
    }
}
