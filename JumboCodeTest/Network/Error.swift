//
//  Error.swift
//  JumboCodeTest
//
//  Created by Joel Youngblood on 8/9/19.
//  Copyright © 2019 Joel Youngblood. All rights reserved.
//

import Foundation

protocol JumboError: Error, CustomStringConvertible { }

enum NetworkError: JumboError {
    case noConnection
    case formationError(url: String)
    case errorCode(code: Int)
    case invalidStatus
    case unknownError
    
    var description: String {
        switch self {
        case .noConnection:
            return "No internet connection detected. If you are not seeing any data, the initial sync must not have been performed. Please check your connectionn and refresh."
        case .formationError(let url):
            return "Failed to form a correct URL for path \(url)"
        case .errorCode(let code):
            return "There was a network error, server returned response code - \(code)"
        case .invalidStatus:
            return "There was an error returned by the API"
        case .unknownError:
            return "An unknown error has occured"
        }
    }
}

enum DecodeError<T>: JumboError {
    case decode(error: Error)
    
    var description: String {
        switch self {
        case .decode(let error):
            return "Decoding model of type \(T.self) failed with error \(error.localizedDescription)"
        }
    }
}

enum ValidationError: JumboError {
    case unsupportedAlgorithm(SecKeyAlgorithm)
    case encodingError
    case crypto
    case invalid
    case param
    case unknown
    
    var description: String {
        switch self {
        case .unsupportedAlgorithm(let algorithm): return "\(algorithm) is not supported by this public key"
        case .encodingError: return "There was an error encoding cryptographic data"
        case .invalid: return "The signature verification failed, no match was found"
        case .crypto: return "An underlying cryptological error occurred"
        case .param: return "An invalid parameter was passed to SecKeyRawVerify"
        case .unknown: return "An unknown error occurred"
        }
    }
}
