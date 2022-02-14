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
        coordinator.container = self
    }
    
    func makeLivePricesViewModel() -> LivePricesViewModel {
        let repository = makeLivePricesRepository()
        return LivePricesViewModel(repository: repository)
    }
    
    func makeEditPortfolioViewModel(with coins: [Coin]) -> EditProfileViewModel {
        let viewModel = EditProfileViewModel()
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
        return LivePricesRepository(networkService: networkService)
    }
    
    // Coin Details
    func makeCoinDetailsNetworkService() -> CoinDetailsNetworkStrategy {
        return CoinDetailsNetworkService()
    }
    
    func makeCoinDetailsRepository() -> CoinDetailsRepository {
        let networkService = makeCoinDetailsNetworkService()
        return CoinDetailsRepository(networkService: networkService)
    }
}
