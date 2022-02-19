//
//  LivePricesViewModel.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Combine
import Foundation

class LivePricesViewModel: ObservableObject {
    enum SortOptions {
        case rank
        case rankReversed
        case holdings
        case holdingsReversed
        case price
        case priceReversed
    }
    
    private let repository: LivePricesRepository
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var filteredCoins: [Coin] = []
    
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var isPortfolioShown = false
    @Published var sortOption = SortOptions.rank
    
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
    
    init(repository: LivePricesRepository) {
        self.repository = repository
        self.addSubscribers()
    }
    
    func getCoins() {
        isLoading = true
        self.repository.getCoins { [weak self] coins in
            guard let self = self else { return }
            if self.allCoins.isEmpty {
                self.hideLaunchScreenPublisher.send()
            }
            self.allCoins = coins
            self.isLoading = false
        }
    }
    
    func didTapEditPortfolio() {
        showEditPortfolioScreenPublisher.send(allCoins)
    }
    
    func didTapCoinRow(with coin: Coin) {
        showCoinDetailsScreenPublisher.send(coin)
    }
    
    func didTapSort(with sort: SortOptions) {
        if sortOption == sort {
            switch sort {
            case .rank: sortOption = .rankReversed
            case .holdings: sortOption = .holdingsReversed
            case .price: sortOption = .priceReversed
            default: break
            }
        } else {
            sortOption = sort
        }
    }
}

private extension LivePricesViewModel {
    func addSubscribers() {
        $searchText
            .combineLatest($allCoins, $sortOption)
            .map (filterAndSortCoins)
            .sink { [weak self] coins in
                
                self?.filteredCoins = coins
            }
            .store(in: &subscriptions)
    }
    
    func filterAndSortCoins(text: String, coins: [Coin], sort: SortOptions) -> [Coin] {
        allCoins = coins
        let filteredCoins = filterCoins(coins, text: text)
        let sortedCoins = sortCoins(filteredCoins, sort: sort)
        return sortedCoins
    }
    
    func filterCoins(_ coins: [Coin], text: String) -> [Coin] {
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
    
    func sortCoins(_ coins: [Coin], sort: SortOptions) -> [Coin] {
        switch sort {
        case .rank:
            return coins.sorted(by: { $0.rank < $1.rank })
        case .rankReversed:
            return coins.sorted(by: { $0.rank > $1.rank })
        case .holdings:
            return coins.sorted(by: { $0.rank < $1.rank })
        case .holdingsReversed:
            return coins.sorted(by: { $0.rank > $1.rank })
        case .price:
            return coins.sorted(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            return coins.sorted(by: { $0.currentPrice < $1.currentPrice })
            
        }
    }
}
