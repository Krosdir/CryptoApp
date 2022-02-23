//
//  LivePricesFakeNetworkService.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Combine
import Foundation

class LivePricesFakeNetworkService: LivePricesNetworkStrategy {
    private let allCoinsPublisher = PassthroughSubject<[Coin], Error>()
    var allCoinsSignal: AnyPublisher<[Coin], Error> {
        allCoinsPublisher.eraseToAnyPublisher()
    }
    
    func getCoins() {
        allCoinsPublisher.send([DeveloperPreview.shared.coin])
    }
}
