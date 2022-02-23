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
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var allCoins: [Coin] = []
    @Published var storedCoins: [Coin] = []
    
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
    
    func getPortfolioCoins() {
        storageService.getPortfolioCoins()
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
        
        $allCoins
            .combineLatest(storageService.coinEntitiesSignal)
            .map { (coins, coinEntities) -> [Coin] in
                coins.compactMap { (coin) -> Coin? in
                    guard let entity = coinEntities.first(where: { $0.coinId == coin.id }) else { return nil }
                    
                    return coin.updateHoldings(amount: entity.amount)
                }
            }
            .sink { [weak self] storedCoins in
                self?.storedCoins = storedCoins
            }
            .store(in: &subscriptions)
    }
}
