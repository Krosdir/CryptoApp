//
//  Date.swift
//  CryptoApp
//
//  Created by Danil on 16.02.2022.
//

import Foundation

extension Date {
    init(dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    func asShortDateString() -> String {
        return shortDateFormatter.string(from: self)
    }
}

private extension Date {
    var shortDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }
}
