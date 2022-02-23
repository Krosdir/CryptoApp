//
//  NetworkStategy.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Combine
import Foundation

protocol LivePricesNetworkStrategy: AnyObject {
    var allCoinsSignal: AnyPublisher<[Coin], Error> { get }
    func getCoins()
}
