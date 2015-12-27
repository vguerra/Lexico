//
//  GlosbeAPI.swift
//  Lexico
//
//  Created by Victor Guerra on 27/12/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import Alamofire


/// Helper struct that encapsulates interaction w/Glosbe API

enum TranslationError : ErrorType {
    case Error1, Error2
}

struct Glosbe {
    private static let dictionaryKey = "dict.1.1.20151116T223221Z.b505e3f3550e1503.a17459cd826bbf796883a82ae23f6a36cc46177b"
    private static let translationKey = "trnsl.1.1.20151116T223538Z.ad543d124ed92780.1151a8f5c62bee4df561562739771bf7d93316c4"
    
    private static let apiURL = "https://glosbe.com/gapi/"
    
    private static let baseUrlParamDict = [
        "from" : "eng",
        "tm" : "false",
        "format" : "json"
        
    ]
    
    private static let fromLanguage = "eng"
    
    static func translate (dest : Language, _ phrase : String) throws -> () {
        let function = "translate"
        var urlParamDict : [String : String] = baseUrlParamDict
        
        urlParamDict["dest"] = dest.code
        urlParamDict["phrase"] = phrase
        
        debugPrint(dest.code)
        
        Alamofire.request(.GET, apiURL + function, parameters: urlParamDict,
            encoding: .URLEncodedInURL, headers: nil).responseJSON { response in
                if response.result.isFailure {
                    
                }
                
                debugPrint(response.result.value)
        }
        
    }
}