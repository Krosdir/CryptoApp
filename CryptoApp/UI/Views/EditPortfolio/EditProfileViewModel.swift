//
//  EditProfileViewModel.swift
//  CryptoApp
//
//  Created by Danil on 13.02.2022.
//

import Combine
import Foundation

class EditProfileViewModel: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    
    @Published var searchText = ""
    @Published var allCoins: [Coin] = []
    @Published var filteredCoins: [Coin] = []
    
    init() {
        addSubscribers()
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
    }
}
