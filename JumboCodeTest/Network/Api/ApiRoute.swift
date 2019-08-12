//
//  APIRoute.swift
//  JumboCodeTest
//
//  Created by Joel Youngblood on 8/9/19.
//  Copyright © 2019 Joel Youngblood. All rights reserved.
//

import Foundation
import Alamofire

typealias JSON = [String: Any]

protocol ApiRoute: URLRequestConvertible {
    var root: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var encoding: ParameterEncoding { get }
    var params: JSON? { get }
}

extension ApiRoute {
    //I go through this step so that we could switch our root url depending on the environment, eg. prod, dev, test etc, as well as it's nice to have the option if differant api's have differant roots
    var root: String {
        return AppConstants.apiRoot
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: root + path) else { throw NetworkError.formationError(url: root + path) }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}

