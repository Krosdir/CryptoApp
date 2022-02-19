//
//  CoinDetailsRepository.swift
//  CryptoApp
//
//  Created by Danil on 14.02.2022.
//

import Foundation

class CoinDetailsRepository {
    private let networkService: CoinDetailsNetworkStrategy
    
    init(networkService: CoinDetailsNetworkStrategy) {
        self.networkService = networkService
    }
    
    // CRUD Methods
    func getDetails(
        for coin: Coin,
        completion: @escaping (CoinDetails) -> Void
    ) {
        networkService.getDetails(for: coin) { result in
            switch result {
            case .failure(let error):
                // TODO: .failure(let error)
                print(error.localizedDescription)
            case .success(let coinDetails):
                completion(coinDetails)
            }
        }
    }
}
