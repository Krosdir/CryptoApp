//
//  AppCoordinator.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import UIKit

public class AppCoordinator: Coordinator {
    
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
