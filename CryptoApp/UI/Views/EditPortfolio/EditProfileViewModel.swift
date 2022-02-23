//
//  EditProfileViewModel.swift
//  CryptoApp
//
//  Created by Danil on 13.02.2022.
//

import Combine
import Foundation

class EditProfileViewModel: ObservableObject {
    private let repository: EditPortfolioRepository
    var storedCoins: [Coin] = []
    
    var subscriptions = Set<AnyCancellable>()
    
    @Published var searchText = ""
    
    @Published var allCoins: [Coin] = []
    @Published var filteredCoins: [Coin] = []
    
    private let updatePortfolioPublisher =  PassthroughSubject<Void, Never>()
    var updatePortfolioSignal: AnyPublisher<Void, Never> {
        updatePortfolioPublisher.eraseToAnyPublisher()
    }
    
    init(repository: EditPortfolioRepository) {
        self.repository = repository
        addSubscribers()
    }
    
    func storeCoin(_ coin: Coin, amount: Double) {
        repository.updateCoin(coin, amount: amount)
    }
}

private extension EditProfileViewModel {
    func addSubscribers() {
        $searchText
            .combineLatest($allCoins)
            .map { (text, allCoins) -> [Coin] in
                let lowercasedText = text.lowercased()
                if lowercasedText.isEmpty {
                    return allCoins
                }
                
                return allCoins.filter { (coin) -> Bool in
                    return coin.name.lowercased().contains(lowercasedText) ||
                    coin.symbol.lowercased().contains(lowercasedText) ||
                    coin.id.lowercased().contains(lowercasedText)
                }
            }
            .sink { [weak self] coins in
                self?.filteredCoins = coins
            }
            .store(in: &subscriptions)
        
        repository.$storedCoins
            .sink { [weak self] storedCoins in
                self?.storedCoins = storedCoins ?? []
                self?.updatePortfolioPublisher.send()
            }
            .store(in: &subscriptions)
    }
}
