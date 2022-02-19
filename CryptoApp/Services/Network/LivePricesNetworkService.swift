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
}

extension LivePricesNetworkService: LivePricesNetworkStrategy {
    func getCoins(completion: @escaping (Result<[Coin], Error>) -> Void) {
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
            .sink { subscribeCompletion in
                switch subscribeCompletion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            } receiveValue: { [weak self] coins in
                completion(.success(coins))
                self?.allCoinsSubscription?.cancel()
            }
    }
}
