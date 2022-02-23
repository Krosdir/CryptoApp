//
//  LivePricesStorageStrategy.swift
//  CryptoApp
//
//  Created by Danil on 23.02.2022.
//

import Foundation

protocol LivePricesStorageStrategy: AnyObject {
    var coinEntitiesSignal: Published<[CoinEntity]>.Publisher { get }
    func getPortfolioCoins()
}
