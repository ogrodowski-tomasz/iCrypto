//
//  String.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 27/04/2022.
//

import Foundation

extension String {

    var removingHTMLOccurances: String {
        // getting rid of useless html addings
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
