//
//  InfoCoordinator.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import SwiftUI
import UIKit

public class InfoCoordinator: Coordinator {
    
    public override init(
        root: UINavigationController,
        parent: Coordinator?
    ) {
        super.init(root: root, parent: parent)
        
        rootNavigationController.isNavigationBarHidden = true
        rootNavigationController.tabBarItem = UITabBarItem(
            title: "Info".uppercased(),
            image: UIImage(systemName: "info.circle"),
            selectedImage: UIImage(systemName: "info.circle.fill")
        )
    }
    
    override func start() {
        let infoViewController = makeInfoViewController()
        rootNavigationController.pushViewController(infoViewController, animated: false)
    }
    
    override func reloadData() {
        super.reloadData()
    }
}

extension InfoCoordinator {
    func makeInfoViewController() -> UIHostingController<InfoView> {
        return UIHostingController(rootView: InfoView())
    }
}
