//
//  Helpers.swift
//  Lexico
//
//  Created by Victor Guerra on 17/04/16.
//  Copyright © 2016 Victor Guerra. All rights reserved.
//

import UIKit

// General helper methods used through out the code
// of the app.

struct Helpers {

    static func generateAttributedText(text : String) -> NSMutableAttributedString {
        let attributedText = try! NSMutableAttributedString(data: text.dataUsingEncoding(NSUnicodeStringEncoding)!,
                                                            options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType],
                                                            documentAttributes: nil)
        let fullRange = NSRange(location: 0, length: attributedText.length)
        attributedText.setAttributes([NSFontAttributeName : UIFont(name : "Symbol", size: 14)!], range: fullRange)
        return attributedText
    }
    
}
