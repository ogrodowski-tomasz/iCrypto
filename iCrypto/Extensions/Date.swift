//
//  Date.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 27/04/2022.
//

import Foundation

extension Date {

    // "2021-03-13T23:18:10.268Z"
    init(coinGeckoString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //sssz - miliseconds
        let date = formatter.date(from: coinGeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }

    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }

    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
}
