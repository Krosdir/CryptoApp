//
//  CoinDetailNetworkService.swift
//  CryptoApp
//
//  Created by Danil on 14.02.2022.
//

import Combine
import Foundation

class CoinDetailsNetworkService: NetworkService {
    private var coinDetailsSubscription: AnyCancellable?
}

extension CoinDetailsNetworkService: CoinDetailsNetworkStrategy {
    func getDetails(
        for coin: Coin,
        completion: @escaping (Result<CoinDetails, Error>) -> Void
    ) {
        let parameters: Parameters = [
            "localization": false,
            "tickers": false,
            "market_data": false,
            "community_data": false,
            "developer_data": true,
            "sparkline": false
        ]
        
        guard let url = URL(
            string: "coins/\(coin.id)",
            relativeTo: NetworkService.baseURL,
            parameters: parameters
        ) else {
            return
        }
        
        coinDetailsSubscription = fetchDataPublisher(from: url)
            .decode(type: CoinDetails.self, decoder: JSONDecoder())
            .sink { subscribeCompletion in
                switch subscribeCompletion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            } receiveValue: { [weak self] coinDetails in
                completion(.success(coinDetails))
                self?.coinDetailsSubscription?.cancel()
            }
    }
}
