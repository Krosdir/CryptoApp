//
//  CoinDetailsNetworkStrategy.swift
//  CryptoApp
//
//  Created by Danil on 14.02.2022.
//

import Combine
import Foundation

protocol CoinDetailsNetworkStrategy: AnyObject {
    var detailsSignal: AnyPublisher<CoinDetails, Error> { get }
    func getDetails(for coin: Coin)
}
