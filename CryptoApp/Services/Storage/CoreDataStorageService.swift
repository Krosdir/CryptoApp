//
//  CoreDataStorageService.swift
//  CryptoApp
//
//  Created by Danil on 24.02.2022.
//

import Combine
import CoreData
import Foundation

class CoreDataStorageService: StorageStrategy {
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
    
    func storeCoin(_ coin: Coin, amount: Double) {
        if let entity = storedEntities.first(where: { $0.coinId == coin.id }) {
            if amount > 0 {
                updateEntity(entity, amount: amount)
            } else {
                deleteEntity(entity)
            }
        } else {
            addCoin(coin, amount: amount)
        }
    }
}

private extension CoreDataStorageService {
    func addCoin(_ coin: Coin, amount: Double) {
        let entity = CoinEntity(context: context)
        entity.coinId = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    func updateEntity(_ entity: CoinEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    func deleteEntity(_ entity: CoinEntity) {
        context.delete(entity)
        applyChanges()
    }
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print("Error saving to Core Data \(error)")
        }
    }
    
    func applyChanges() {
        save()
        getPortfolioCoins()
    }
}
