//
//  LivePricesRepository.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Combine
import Foundation

class LivePricesRepository {
    private let networkService: LivePricesNetworkStrategy
    private let storageService: LivePricesStorageStrategy
    
    private var storedCoins: [Coin] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var allCoins: [Coin] = []
    
    init(
        networkService: LivePricesNetworkStrategy,
        storageService: LivePricesStorageStrategy
    ) {
        self.networkService = networkService
        self.storageService = storageService
        addSubscribers()
    }
    
    // CRUD Methods
    func getCoins() {
        networkService.getCoins()
    }
    
    func getStoredCoins(completion: @escaping ([Coin]) -> Void) {
        storageService.getCoinEnities { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let coinEntities):
                guard let self = self else { return }
                let coins = self.allCoins.compactMap { (coin) -> Coin? in
                    guard let entity = coinEntities.first(where: { $0.coinId == coin.id }) else { return nil }
                    
                    return coin.updateHoldings(amount: entity.amount)
                }
                self.storedCoins = coins
                completion(coins)
            }
        }
    }
}

private extension LivePricesRepository {
    func addSubscribers() {
        networkService.allCoinsSignal
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                default:
                    break
                }
            }, receiveValue: { [weak self] coins in
                self?.allCoins = coins
            })
            .store(in: &subscriptions)
    }
}
