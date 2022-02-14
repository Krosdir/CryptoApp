//
//  CoinDetailsNetworkStrategy.swift
//  CryptoApp
//
//  Created by Danil on 14.02.2022.
//

import Foundation

protocol CoinDetailsNetworkStrategy: AnyObject {
    func getDetails(for coin: Coin,
                    completion: @escaping (Result<CoinDetails, Error>) -> Void)
}
