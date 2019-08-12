//
//  Validator.swift
//  JumboCodeTest
//
//  Created by Joel Youngblood on 8/10/19.
//  Copyright © 2019 Joel Youngblood. All rights reserved.
//

import Foundation

//The idea here was to allow for dependency injection for testing potential differant algos / keys / etc
struct Validator {
    
    let publicKey: String
    let keySize: Int
    let algorithm: SecKeyAlgorithm
    
    private var attributesDictionary: [String: Any] {
        return [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: NSNumber(value: keySize), //2048
            kSecReturnPersistentRef as String: true as NSObject
        ]
    }
    
    private var secKey: SecKey? {
        guard let keyData = Data(base64Encoded: publicKey) else {
            print("Can't form the key data")
            return nil
        }
        return SecKeyCreateWithData(keyData as CFData, attributesDictionary as CFDictionary, nil)
    }
    
    /**
     Given a challenge object, attempts to validate the signnature. If the signature is found to be valid, the decoded script is returned as the success object on the Result, otherwise a ValidationError is returned.
     
     - returns:
    Result<String, ValidationError>
     
     - parameters:
        - challenge: The challenge object to attempt to validate.
     **/
    func validate(challenge: Challenge) -> Result<String, ValidationError> {
        guard let publicKey = secKey else { return .failure(ValidationError.encodingError) }
        guard let signatureData = Data(base64Encoded: challenge.signature) else { return .failure(ValidationError.encodingError) }
        guard let payloadData = Data(base64Encoded: challenge.payload) else { return .failure(ValidationError.encodingError) }
        
        guard SecKeyIsAlgorithmSupported(publicKey, .verify, algorithm) else {
            return .failure(ValidationError.unsupportedAlgorithm(algorithm))
        }
        
        //Uncomment these two lines...
//        guard let payload = challenge.decodedPayload else { return .failure(ValidationError.encodingError) }
//        return .success(payload)
        
        //...and comment these seven lines...
        var error: Unmanaged<CFError>?
        if SecKeyVerifySignature(publicKey, algorithm, payloadData as CFData, signatureData as CFData, &error) {
            guard let payload = challenge.decodedPayload else { return .failure(ValidationError.encodingError) }
            return .success(payload)
        } else {
            print(error?.takeRetainedValue())
            return .failure(ValidationError.invalid)
        }
        //...to see it work...
    }
}
