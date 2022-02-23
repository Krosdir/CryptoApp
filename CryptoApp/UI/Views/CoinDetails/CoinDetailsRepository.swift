//
//  CoinDetailsRepository.swift
//  CryptoApp
//
//  Created by Danil on 14.02.2022.
//

import Combine
import Foundation

class CoinDetailsRepository {
    private let networkService: CoinDetailsNetworkStrategy
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var coinDetails: CoinDetails?
    
    init(networkService: CoinDetailsNetworkStrategy) {
        self.networkService = networkService
        addSubscribers()
    }
    
    // CRUD Methods
    func getDetails(for coin: Coin) {
        networkService.getDetails(for: coin)
    }
}

private extension CoinDetailsRepository {
    func addSubscribers() {
        networkService.detailsSignal
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                default:
                    break
                }
            }, receiveValue: { [weak self] coinDetails in
                self?.coinDetails = coinDetails
            })
            .store(in: &subscriptions)

    }
}
