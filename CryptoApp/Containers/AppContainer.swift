//
//  AppContainer.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Foundation
import UIKit

public class AppContainer {
    
    // MARK: - Long-Lived Dependancies
    
    let appCoordinator: AppCoordinator
    
    // MARK: - Methods
    public init() {
        func makeAppCoordinator() -> AppCoordinator {
            let navigationController = UINavigationController()
            return AppCoordinator(root: navigationController)
        }
        
        func makeChildrenCoordinators() {
            let livePricesCoordinator = makeLivePricesCoordinator()
            let infoCoordinator = makeInfoCoordinator()
            
            appCoordinator.children = [
                livePricesCoordinator,
                infoCoordinator
            ]
        }
        
        func makeLivePricesCoordinator() -> Coordinator {
            let livePricesContainer = LivePricesContainer(appContainer: self)
            return livePricesContainer.coordinator
        }
        
        func makeInfoCoordinator() -> Coordinator {
            let navigationController = UINavigationController()
            
            return InfoCoordinator(
                root: navigationController,
                parent: appCoordinator
            )
        }
        
        appCoordinator = makeAppCoordinator()
        makeChildrenCoordinators()
        appCoordinator.container = self
    }
}

extension AppContainer {
    func makeLaunchViewModel() -> LaunchViewModel {
        return LaunchViewModel()
    }
}
