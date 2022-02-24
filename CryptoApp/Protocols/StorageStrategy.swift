//
//  StorageStrategy.swift
//  CryptoApp
//
//  Created by Danil on 24.02.2022.
//

import Foundation

protocol StorageStrategy: AnyObject {
    var coinEntitiesSignal: Published<[CoinEntity]>.Publisher { get }
    func storeCoin(_ coin: Coin, amount: Double)
    func getPortfolioCoins()
}
