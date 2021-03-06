//
//  LivePricesContrainer.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Foundation
import UIKit

public class LivePricesContainer {
    
    let coordinator: LivePricesCoordinator
    let coreDataStack: CoreDataStack
    let storageService: StorageStrategy
    
    // MARK: - Methods
    public init(appContainer: AppContainer) {
        func makeLivePricesCoordinator() -> LivePricesCoordinator {
            let navigationController = UINavigationController()
            return LivePricesCoordinator(
                root: navigationController,
                parent: appContainer.appCoordinator
            )
        }

        self.coordinator = makeLivePricesCoordinator()
        self.coreDataStack = appContainer.coreDataStack
        self.storageService = CoreDataStorageService(context: self.coreDataStack.mainContext)
        coordinator.container = self
    }
}

extension LivePricesContainer {
    func makeLivePricesViewModel() -> LivePricesViewModel {
        let repository = makeLivePricesRepository()
        return LivePricesViewModel(repository: repository)
    }
    
    func makeEditPortfolioViewModel(with coins: [Coin]) -> EditProfileViewModel {
        let repository = makeEditPortfolioRepository(with: coins)
        let viewModel = EditProfileViewModel(repository: repository)
        viewModel.allCoins = coins
        return viewModel
    }
    
    func makeCoinDetailsViewModel(for coin: Coin) -> CoinDetailsViewModel {
        let repository = makeCoinDetailsRepository()
        return CoinDetailsViewModel(
            coin: coin,
            repository: repository
        )
    }
}

private extension LivePricesContainer {
    // Live Prices
    func makeLivePricesNetworkService() -> LivePricesNetworkStrategy {
        #if DEBUG
        return LivePricesFakeNetworkService()
        #else
        return LivePricesNetworkService()
        #endif
    }
    
    func makeLivePricesRepository() -> LivePricesRepository {
        let networkService = makeLivePricesNetworkService()
        return LivePricesRepository(
            networkService: networkService,
            storageService: storageService
        )
    }
    
    // Coin Details
    func makeCoinDetailsNetworkService() -> CoinDetailsNetworkStrategy {
        return CoinDetailsNetworkService()
    }
    
    func makeCoinDetailsRepository() -> CoinDetailsRepository {
        let networkService = makeCoinDetailsNetworkService()
        return CoinDetailsRepository(networkService: networkService)
    }
    
    // Edit Portfolio
    func makeEditPortfolioRepository(with coins: [Coin]) -> EditPortfolioRepository {
        return EditPortfolioRepository(storageService: storageService, with: coins)
    }
}
