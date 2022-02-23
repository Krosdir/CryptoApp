//
//  EditPortfolioStorageStrategy.swift
//  CryptoApp
//
//  Created by Danil on 23.02.2022.
//

import Foundation

protocol EditPortfolioStorageStrategy: AnyObject {
    var coinEntitiesSignal: Published<[CoinEntity]>.Publisher { get }
    func storeCoin(_ coin: Coin, amount: Double)
    func getPortfolioCoins()
}
