//
//  StringExtensions.swift
//  Stickies
//
//  Created by Ion Caus on 28.02.2023.
//

import Foundation

extension String {
    
    var htmlToString: String { htmlToAttributedString?.string ?? "" }
    
    var htmlToAttributedString: NSAttributedString? {
        return try? NSAttributedString(
            data: Data(utf8),
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil)
    }
    
    var localeLanguageName: String {
        let locale: Locale = .current
        
        if let language = locale.localizedString(forLanguageCode: self),
           let region = self.split(separator: "-").last {
            
            return "\(language) (\(region))"
        }
        return self
    }
}
