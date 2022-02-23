//
//  LivePricesStorageService.swift
//  CryptoApp
//
//  Created by Danil on 23.02.2022.
//

import Combine
import CoreData
import Foundation

class LivePricesStorageService: LivePricesStorageStrategy {
    private let context: NSManagedObjectContext
    
    @Published private var storedEntities: [CoinEntity] = []
    
    var coinEntitiesSignal: Published<[CoinEntity]>.Publisher { $storedEntities }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        getPortfolioCoins()
    }
    
    func getPortfolioCoins() {
        let request = CoinEntity.fetchRequest()
        do {
            storedEntities = try context.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
    }
}
