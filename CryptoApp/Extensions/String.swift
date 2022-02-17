//
//  String.swift
//  CryptoApp
//
//  Created by Danil on 17.02.2022.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )
    }
}
