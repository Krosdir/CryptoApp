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
    
    private var allConstCoins: [Coin] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
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
        repository.getCoins()
    }
    
    func getPortfolioCoins() {
        repository.getPortfolioCoins()
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
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map (filterAndSortCoins)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &subscriptions)
        
        repository.$allCoins
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] allCoins in
                guard let self = self else { return }
                if self.allCoins.isEmpty && !allCoins.isEmpty {
                    self.hideLaunchScreenPublisher.send()
                }
                self.allConstCoins = allCoins
                self.allCoins = allCoins
                self.isLoading = false
            })
            .store(in: &subscriptions)
        
        $allCoins
            .combineLatest(repository.$storedCoins)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] coins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins)
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
            return allConstCoins
        }
        
        return allConstCoins.filter { (coin) -> Bool in
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
    
    func mapAllCoinsToPortfolioCoins(_ coins: [Coin], portfolioCoins: [Coin]) -> [Coin] {
        coins
            .compactMap { (coin) -> Coin? in
                guard let firstCoin = portfolioCoins.first(where: { $0.id == coin.id }) else { return nil }
                return firstCoin
            }
    }
    
    func sortPortfolioCoinsIfNeeded(_ coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
}
