//
//  Challenge.swift
//  JumboCodeTest
//
//  Created by Joel Youngblood on 8/9/19.
//  Copyright © 2019 Joel Youngblood. All rights reserved.
//

import Foundation
import Alamofire

enum Challenges: ApiRoute {
    
    case codeChallenge
    
    var path: String {
        switch self {
        case .codeChallenge: return "/interview_challenge/challenge.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .codeChallenge: return .get
        }
    }
    
    var params: JSON? {
        return nil
    }
}
