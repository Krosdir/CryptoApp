//
//  LivePricesRepository.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Foundation

class LivePricesRepository {
    private let networkService: LivePricesNetworkStrategy
    
    init(networkService: LivePricesNetworkStrategy) {
        self.networkService = networkService
    }
    
    // CRUD Methods
    func getCoins(completion: @escaping ([Coin]) -> Void) {
        networkService.getCoins { result in
            switch result {
            case .failure(let error):
                // TODO: .failure(let error)
                print(error.localizedDescription)
            case .success(let coins):
                completion(coins)
            }
        }
    }
}
