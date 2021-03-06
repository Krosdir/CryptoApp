//
//  AppCoordinator.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import SwiftUI
import UIKit

public class AppCoordinator: Coordinator {
    
    weak var container: AppContainer?
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
        let launchViewController = makeLaunchViewController() ?? UIViewController()
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
    func makeLaunchViewController() -> UIHostingController<LaunchView>? {
        guard let viewModel = container?.makeLaunchViewModel() else { return nil }
        return UIHostingController(rootView: LaunchView(viewModel: viewModel))
    }
    
    func popViewController() {
        rootNavigationController.popViewController(animated: true)
    }
}
