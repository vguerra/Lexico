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
    static private let preferredFont = UIFont(name: "Symbol", size: 14)!

    static func generateAttributedText(text : String, highlightRange : NSRange? = nil) -> NSMutableAttributedString {
        let attributedText = try! NSMutableAttributedString(data: text.dataUsingEncoding(NSUnicodeStringEncoding)!,
                                                            options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType],
                                                            documentAttributes: nil)
        let fullRange = NSRange(location: 0, length: attributedText.length)
        attributedText.setAttributes([NSFontAttributeName : preferredFont], range: fullRange)
        if let range = highlightRange {
            attributedText.setAttributes(
                [NSBackgroundColorAttributeName: UIColor.lightGrayColor(), NSFontAttributeName : preferredFont],
                range: range
            )
        }
        return attributedText
    }
}
