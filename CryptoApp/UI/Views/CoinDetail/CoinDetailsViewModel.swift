//
//  CoinDetailsViewModel.swift
//  CryptoApp
//
//  Created by Danil on 14.02.2022.
//

import Combine
import Foundation

class CoinDetailsViewModel: ObservableObject {
    let repository: CoinDetailsRepository
    
    var subscriptions = Set<AnyCancellable>()
    
    let coin: Coin
    @Published var coinDetails: CoinDetails!
    
    init(
        coin: Coin,
        repository: CoinDetailsRepository
    ) {
        self.coin = coin
        self.repository = repository
        
        self.repository.getDetails(for: coin) { [weak self] coinDetails in
            self?.coinDetails = coinDetails
        }
    }
}
