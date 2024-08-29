//
//  StringExt.swift
//  BBQuotes17
//
//  Created by Artem Golovchenko on 2024-08-29.
//

import Foundation

extension String {
    func removeSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeCaseAndSpace() -> String {
        self.removeSpaces().lowercased()
    }
}
