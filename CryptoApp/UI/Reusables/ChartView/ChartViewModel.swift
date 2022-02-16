//
//  ChartViewModel.swift
//  CryptoApp
//
//  Created by Danil on 16.02.2022.
//

import Foundation

class ChartViewModel: ObservableObject {
    private let coin: Coin
    
    let data: [Double]
    let maxY: Double
    let minY: Double
    
    private let startingDate: Date
    private let endingDate: Date
    
    private let priceChange: Double
    
    var maxYLabel: String { maxY.formattedWithAbbreviations() }
    var minYLabel: String { minY.formattedWithAbbreviations() }
    var midYLabel: String { ((maxY + minY) / 2).formattedWithAbbreviations() }
    
    var minXLabel: String { startingDate.asShortDateString() }
    var maxXLabel: String { endingDate.asShortDateString() }
    
    var isPositive: Bool { priceChange > 0 }
    
    init(coin: Coin) {
        self.coin = coin
        
        self.data = coin.sparklineIn7D?.price ?? []
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
        
        self.priceChange = (data.last ?? 0) - (data.first ?? 0)
        
        endingDate = Date(dateString: coin.lastUpdated ?? "")
        let calendar = Calendar.autoupdatingCurrent
        startingDate = calendar.date(byAdding: .day, value: -7, to: endingDate) ?? endingDate
    }
}
