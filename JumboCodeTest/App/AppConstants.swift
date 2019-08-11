//
//  AppConstants.swift
//  JumboCodeTest
//
//  Created by Joel Youngblood on 8/9/19.
//  Copyright © 2019 Joel Youngblood. All rights reserved.
//

import Foundation

struct AppConstants {
    
    static let apiRoot = "https://webclients.jumboprivacy.com"
    private static let publicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAufKvMjy2EMPsHXlP/Y81BHrOEZm84B84C+/GwDqIzoEH4XHn5Vj3N3+QNG/WT9TZv+tufm6i9jNQUosKztXyyZSGYhtypLVb2oni4oDn3a/UXOnJjSk9nNohcYghQRZ++1nRs+MUYBQKAHZDxle6MytDYdBxV3gyfDhnjilqLe/91KbDaB7EjL3ffxfop+QFZGExqcfWxq4gL92mlzNrSi/N0lRv5nAsicAyNSBAU4RJYW/ECPPvgeV9KXYrcCodx+Ed+ap3FJaUeZF0KJivBaKOlBpWGGqevdOCykb4ub4ePnQB/6s81MxVHfAoUBKGBsYfy1wuwkWFDH0c9SOmcQIDAQAB"
    
    static let defaultValidator = Validator(publicKey: AppConstants.publicKey, keySize: 2048, algorithm: .rsaSignatureDigestPKCS1v15SHA256)    
}
