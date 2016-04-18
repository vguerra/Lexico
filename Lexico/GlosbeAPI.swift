//
//  GlosbeAPI.swift
//  Lexico
//
//  Created by Victor Guerra on 27/12/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import Alamofire

typealias TrnResult = RResult<Translation, NSError>.t

struct Glosbe {
    private static let apiURL = "https://glosbe.com/gapi/"
    private static let AdmitedExampleLength = 300
    private static let baseUrlParamDict = [
        "tm" : "true",
        "format" : "json"
    ]
    
    static func translate (from: Language, _ dest : Language, _ phrase : String, _ handler : (TrnResult) -> ()) {
        let function = "translate"
        var urlParamDict : [String : String] = baseUrlParamDict
        
        urlParamDict["from"] = from.code
        urlParamDict["dest"] = dest.code
        urlParamDict["phrase"] = phrase
        urlParamDict["pretty"] = "true"
        
        Alamofire.request(.GET, apiURL + function, parameters: urlParamDict,
            encoding: .URLEncodedInURL, headers: nil).responseJSON { response in
                if response.result.isFailure {
                    handler( .Failure(response.result.error!) )
                } else {
                    handler(parseTranslationJSON(response.result.value!))
                }
        }
    }
    
    static func parseTranslationJSON(json: AnyObject) -> TrnResult {
        guard let ok = json["result"] as? String where ok == "ok" else {
            return .Failure(NSError(domain: "parsing Translation error", code: 0, userInfo: nil))
        }
        
        if let dest = json["dest"] as? String,
            let from = json["from"] as? String,
            let tucObjs = json["tuc"] as? [[String : AnyObject]] {
                
                // processing tuc array of objects
                let phrasesFull = tucObjs.flatMap() { tuc -> String? in
                    if let phraseObj = tuc["phrase"] as? [String:String] {
                        return phraseObj["text"]
                    }
                    return nil
                }

                let phrases = Array(phrasesFull[0 ..< min(10, phrasesFull.count)])
                
                // processing example array of objects
                let exampleObjs = json["examples"] as? [[String : AnyObject]]
            let examples = exampleObjs?.flatMap() { example -> (originalText: String , translatedText : String)? in
                    let first = example["first"] as! String
                    let second = example["second"] as! String

                    if second.characters.count > AdmitedExampleLength || first.characters.count > AdmitedExampleLength {
                        return nil
                    }
                    return (originalText: example["first"] as! String, translatedText: example["second"] as! String)
                }
                
                return .Success(Translation(from: from, dest: dest, phrases: phrases, examples: examples ?? []))
        }
        
        return .Failure(NSError(domain: "parsing Translation error", code: 1, userInfo: nil))
        
    }
}
