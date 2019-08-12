//
//  Network.swift
//  JumboCodeTest
//
//  Created by Joel Youngblood on 8/9/19.
//  Copyright © 2019 Joel Youngblood. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

final class Network {
    
    private static let reachability = NetworkReachabilityManager()!
    
    /**
     Performs a request for the given ApiRoute and returns the response data
     
     - returns:
    Observable<Data>
     
     - parameters:
        - route: The ApiRoute that you would like to make the request on.
     **/
    static func request(from route: ApiRoute) -> Observable<Data> {
        if !reachability.isReachable {
            return Observable.error(NetworkError.noConnection)
        } else {
            return RxAlamofire.request(route).validate().responseData().flatMap { response, data -> Observable<Data> in
                if response.statusCode == 200 {
                    return Observable.just(data)
                } else {
                    return Observable.error(NetworkError.errorCode(code: response.statusCode))
                }
            }
        }
    }
}
