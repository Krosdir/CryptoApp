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
    var viewModel: LivePricesViewModel?
    
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
    
    func makeEditPortfolioViewModel() -> EditProfileViewModel {
        let viewModel = EditProfileViewModel()
        viewModel.allCoins = self.viewModel?.allCoins ?? []
        return viewModel
    }
}

private extension LivePricesContainer {
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
}
