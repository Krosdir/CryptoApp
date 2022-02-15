//
//  StatisticsInfo.swift
//  CryptoApp
//
//  Created by Danil on 15.02.2022.
//

import Foundation

struct StatisticsInfo: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(
        title: String,
        value: String,
        percentageChange: Double? = nil
    ) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
