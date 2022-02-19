//
//  AppCoordinator.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import SwiftUI
import UIKit

public class AppCoordinator: Coordinator {
    
    var container: AppContainer!
    let tabBarController = UITabBarController()
    
    public override init(
        root: UINavigationController,
        parent: Coordinator? = nil
    ) {
        super.init(root: root, parent: parent)
        
        rootNavigationController.navigationBar.isHidden = true
        
        rootNavigationController.pushViewController(tabBarController, animated: false)
        
    }
    
    override func start() {
        let launchViewController = makeLaunchViewController()
        rootNavigationController.pushViewController(launchViewController, animated: false)
        
        children.forEach({ $0.start() })
        
        tabBarController.setViewControllers(
            children.map { $0.rootNavigationController },
            animated: false
        )
        
    }
    
    override func reloadData() {
        super.reloadData()
    }
    
    override func childDidFinish(_ child: Coordinator) {
        super.childDidFinish(child)
    }
}

extension AppCoordinator {
    func makeLaunchViewController() -> UIHostingController<LaunchView> {
        let viewModel = container.makeLaunchViewModel()
        return UIHostingController(rootView: LaunchView(viewModel: viewModel))
    }
    
    func popViewController() {
        rootNavigationController.popViewController(animated: true)
    }
}
