//
//  LivePricesNetworkService.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Combine
import Foundation

class LivePricesNetworkService: NetworkService {
    private var allCoinsSubscription: AnyCancellable?
    
    private let allCoinsPublisher = PassthroughSubject<[Coin], Error>()
}

extension LivePricesNetworkService: LivePricesNetworkStrategy {
    var allCoinsSignal: AnyPublisher<[Coin], Error> {
        allCoinsPublisher.eraseToAnyPublisher()
    }
    
    func getCoins() {
        let parameters: Parameters = [
            "vs_currency": "usd",
            "order": "market_cap_desc",
            "per_page": 200,
            "page": 1,
            "sparkline": true,
            "price_change_percentage": "24h"
        ]
        
        guard let url = URL(
            string: "coins/markets",
            relativeTo: NetworkService.baseURL,
            parameters: parameters
        ) else {
            return
        }
        
        allCoinsSubscription = fetchDataPublisher(from: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink { [weak self] subscribeCompletion in
                switch subscribeCompletion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.allCoinsPublisher.send(completion: .failure(error))
                }
            } receiveValue: { [weak self] coins in
                self?.allCoinsPublisher.send(coins)
                self?.allCoinsSubscription?.cancel()
            }
    }
}
