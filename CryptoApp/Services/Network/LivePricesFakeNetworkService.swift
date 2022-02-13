//
//  LivePricesFakeNetworkService.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Foundation

class LivePricesFakeNetworkService: LivePricesNetworkStrategy {
    func getCoins(completion: @escaping (Result<[Coin], Error>) -> Void) {
        completion(.success([DeveloperPreview.shared.coin]))
    }
}
