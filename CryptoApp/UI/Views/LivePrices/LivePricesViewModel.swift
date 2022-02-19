//
//  LivePricesViewModel.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Combine
import Foundation

class LivePricesViewModel: ObservableObject {
    let repository: LivePricesRepository
    
    var subscriptions = Set<AnyCancellable>()
    
    private let showEditPortfolioScreenPublisher = PassthroughSubject<[Coin], Never>()
    var showEditPortfolioScreenSignal: AnyPublisher<[Coin], Never> {
        showEditPortfolioScreenPublisher.eraseToAnyPublisher()
    }
    
    private let showCoinDetailsScreenPublisher = PassthroughSubject<Coin, Never>()
    var showCoinDetailsScreenSignal: AnyPublisher<Coin, Never> {
        showCoinDetailsScreenPublisher.eraseToAnyPublisher()
    }
    
    private let hideLaunchScreenPublisher =  PassthroughSubject<Void, Never>()
    var hideLaunchScreenSignal: AnyPublisher<Void, Never> {
        hideLaunchScreenPublisher.eraseToAnyPublisher()
    }
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    init(repository: LivePricesRepository) {
        self.repository = repository
    }
    
    func getCoins() {
        self.repository.getCoins { [weak self] coins in
            guard let self = self else { return }
            self.allCoins = coins
            
            self.hideLaunchScreenPublisher.send()
        }
    }
    
    func didTapEditPortfolio() {
        showEditPortfolioScreenPublisher.send(allCoins)
    }
    
    func didTapCoinRow(with coin: Coin) {
        showCoinDetailsScreenPublisher.send(coin)
    }
}
