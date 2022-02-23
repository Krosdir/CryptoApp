//
//  CoinRowViewModel.swift
//  CryptoApp
//
//  Created by Danil on 23.02.2022.
//

import Foundation

class CoinRowViewModel: ObservableObject {
    let coin: Coin
    let showHoldingsCulums: Bool
    
    init(
        coin: Coin,
        showHoldingsCulums: Bool
    ) {
        self.coin = coin
        self.showHoldingsCulums = showHoldingsCulums
    }
}
