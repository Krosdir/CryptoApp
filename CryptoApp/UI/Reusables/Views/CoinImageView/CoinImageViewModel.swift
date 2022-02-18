//
//  CoinImageViewModel.swift
//  CryptoApp
//
//  Created by Danil on 06.01.2022.
//

import Foundation

class CoinImageViewModel: ObservableObject {
    var url: URL?
    
    init(coin: Coin) {
        url = URL(string: coin.image)
    }
}
