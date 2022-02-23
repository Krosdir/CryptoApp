//
//  CoinEntity+CoreDataProperties.swift
//  CryptoApp
//
//  Created by Danil on 23.02.2022.
//
//

import Foundation
import CoreData


extension CoinEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoinEntity> {
        return NSFetchRequest<CoinEntity>(entityName: "CoinEntity")
    }

    @NSManaged public var coinId: String?
    @NSManaged public var amount: Double

}

extension CoinEntity : Identifiable {

}
