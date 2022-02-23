//
//  EditPortfolioRepository.swift
//  CryptoApp
//
//  Created by Danil on 23.02.2022.
//

import Combine
import Foundation

class EditPortfolioRepository {
    private let storageService: EditPortfolioStorageStrategy
    private let coins: [Coin]
    private var subscription = Set<AnyCancellable>()
    
    @Published var storedCoins: [Coin]?
    
    init(
        storageService: EditPortfolioStorageStrategy,
        with coins: [Coin]
    ) {
        self.storageService = storageService
        self.coins = coins
        self.storageService.getPortfolioCoins()
        addSubscribers()
    }
    
    // CRUD Methods
    func updateCoin(_ coin: Coin, amount: Double) {
        storageService.storeCoin(coin, amount: amount)
    }
}

private extension EditPortfolioRepository {
    func addSubscribers() {
        storageService.coinEntitiesSignal
            .map { [weak self] (coinEntities) -> [Coin] in
                guard let self = self else { return [] }
                return self.coins.compactMap { (coin) -> Coin? in
                    guard let entity = coinEntities.first(where: { $0.coinId == coin.id }) else { return nil }
                    
                    return coin.updateHoldings(amount: entity.amount)
                }
            }
            .sink { [weak self] storedCoins in
                self?.storedCoins = storedCoins
            }
            .store(in: &subscription)
    }
}
