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
    let coreDataStack: CoreDataStack
    lazy var livePricesContainer: LivePricesContainer = {
        return LivePricesContainer(appContainer: self)
    }()
    
    // MARK: - Methods
    public init() {
        func makeAppCoordinator() -> AppCoordinator {
            let navigationController = UINavigationController()
            return AppCoordinator(root: navigationController)
        }
        
        func makeChildrenCoordinators() {
            let infoCoordinator = makeInfoCoordinator()
            
            appCoordinator.children = [
                livePricesContainer.coordinator,
                infoCoordinator
            ]
        }
        
        func makeInfoCoordinator() -> Coordinator {
            let navigationController = UINavigationController()
            
            return InfoCoordinator(
                root: navigationController,
                parent: appCoordinator
            )
        }
        
        func makeCoreDataStack() -> CoreDataStack {
            let modelName = (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "") + "Model"
            return CoreDataStack(modelName: modelName)
        }
        
        appCoordinator = makeAppCoordinator()
        coreDataStack = makeCoreDataStack()
        makeChildrenCoordinators()
        appCoordinator.container = self
    }
}

extension AppContainer {
    func makeLaunchViewModel() -> LaunchViewModel {
        return LaunchViewModel()
    }
}
