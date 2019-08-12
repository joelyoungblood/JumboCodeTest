//
//  Request.swift
//  JumboCodeTest
//
//  Created by Joel Youngblood on 8/9/19.
//  Copyright © 2019 Joel Youngblood. All rights reserved.
//

import Foundation
import RxSwift

struct Request {
    
    
    /**
     Performs a network request to get the challenge
     
     - returns:
     Observable<Challenge>
     
     **/
    static func requestChallenge() -> Observable<Challenge> {
        return Network.request(from: Challenges.codeChallenge).map { data in
            do {
                return try JSONDecoder().decode(Challenge.self, from: data)
            } catch let error {
                throw DecodeError<Challenge>.decode(error: error)
            }
        }
    }
}
