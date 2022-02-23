//
//  CoinDetailsViewModel.swift
//  CryptoApp
//
//  Created by Danil on 14.02.2022.
//

import Combine
import Foundation

class CoinDetailsViewModel: ObservableObject {
    private let repository: CoinDetailsRepository
    
    @Published var overviewStatistics: [StatisticsInfo] = []
    @Published var additionalStatistics: [StatisticsInfo] = []
    
    @Published var description: String?
    @Published var websiteLink: String?
    @Published var redditLink: String?
    @Published var isLoading = false
    @Published var coinDetails: CoinDetails!
    
    var subscriptions = Set<AnyCancellable>()
    
    let coin: Coin
    
    init(
        coin: Coin,
        repository: CoinDetailsRepository
    ) {
        self.coin = coin
        self.repository = repository
        self.addSubscribers()
        
        self.overviewStatistics = getOverviewStats()
        
        self.isLoading = true
        self.repository.getDetails(for: coin)
    }
}

private extension CoinDetailsViewModel {
    func addSubscribers() {
        repository.$coinDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coinDetails in
                guard let self = self,
                      let details = coinDetails else { return }
                self.coinDetails = details

                self.description = details.description?.en?.removingHTMLOccurances
                self.websiteLink = details.links?.homepage?.first
                self.redditLink = details.links?.subredditURL
                
                self.additionalStatistics = self.getAdditionalStats()
                self.isLoading = false
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Overview Stats
private extension CoinDetailsViewModel {
    func getOverviewStats() -> [StatisticsInfo] {
        let priceStats = getPriceStats()
        let marketCapStats = getMarketCapStats()
        let rankStats = getRankStats()
        let volumeStats = getVolumeStats()

        return [
            priceStats,
            marketCapStats,
            rankStats,
            volumeStats
        ]
    }
    
    func getPriceStats() -> StatisticsInfo {
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H
        return StatisticsInfo(
            title: "Current Price",
            value: price,
            percentageChange: pricePercentChange
        )
    }
    
    func getMarketCapStats() -> StatisticsInfo {
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coin.marketCapChangePercentage24H
        return StatisticsInfo(
            title: "Market Capitalization",
            value: marketCap,
            percentageChange: marketCapChange
        )
    }
    
    func getRankStats() -> StatisticsInfo {
        let rank = "\(coin.rank)"
        return StatisticsInfo(title: "Rank", value: rank)
    }
    
    func getVolumeStats() -> StatisticsInfo {
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        return StatisticsInfo(title: "Volume", value: volume)
    }
}

// MARK: - Additional Stats
private extension CoinDetailsViewModel {
    func getAdditionalStats() -> [StatisticsInfo] {
        let highStats = getHighStats()
        let lowStats = getLowStats()
        let priceChangeStats = getPriceChangeStats()
        let marketCapChangeStats = getMarketCapChangeStats()
        let blockStats = getBlockStats()
        let hashingStats = getHashingStats()

        return [
            highStats,
            lowStats,
            priceChangeStats,
            marketCapChangeStats,
            blockStats,
            hashingStats
        ]
    }
    
    func getHighStats() -> StatisticsInfo {
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        return StatisticsInfo(title: "24h High", value: high)
    }
    
    func getLowStats() -> StatisticsInfo {
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        return StatisticsInfo(title: "24h Low", value: low)
    }
    
    func getPriceChangeStats() -> StatisticsInfo {
        let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coin.priceChangePercentage24H
        return StatisticsInfo(
            title: "24h Price Change",
            value: priceChange,
            percentageChange: pricePercentChange
        )
    }
    
    func getMarketCapChangeStats() -> StatisticsInfo {
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        return StatisticsInfo(
            title: "24h Market Cap Change",
            value: marketCapChange,
            percentageChange: marketCapPercentChange
        )
    }
    
    func getBlockStats() -> StatisticsInfo {
        let blockTime = coinDetails.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        return StatisticsInfo(title: "Block Time", value: blockTimeString)
    }
    
    func getHashingStats() -> StatisticsInfo {
        let hashing = coinDetails.hashingAlgorithm ?? "n/a"
        return StatisticsInfo(title: "Hashing Algorithm", value: hashing)
    }
}
