//
//  NetworkStategy.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Foundation

protocol LivePricesNetworkStrategy: AnyObject {
    func getCoins(completion: @escaping (Result<[Coin], Error>) -> Void)
}
