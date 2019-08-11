//
//  Validator.swift
//  JumboCodeTest
//
//  Created by Joel Youngblood on 8/10/19.
//  Copyright © 2019 Joel Youngblood. All rights reserved.
//

import Foundation

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
            debugPrint("Can't form the key data")
            return nil
        }
        return SecKeyCreateWithData(keyData as CFData, attributesDictionary as CFDictionary, nil)
    }
    
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
            return .failure(ValidationError.invalid)
        }
        //...to see it magically work...
    }
}
