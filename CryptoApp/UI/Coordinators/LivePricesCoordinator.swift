//
//  LivePricesCoordinator.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Foundation

import Combine
import SwiftUI
import UIKit

public class LivePricesCoordinator: Coordinator {
    
    var container: LivePricesContainer!
    
    public override init(
        root: UINavigationController,
        parent: Coordinator?
    ) {
        super.init(root: root, parent: parent)
        
        rootNavigationController.isNavigationBarHidden = true
        rootNavigationController.tabBarItem = UITabBarItem(
            title: "Live Prices".uppercased(),
            image: UIImage(systemName: "dollarsign.circle"),
            selectedImage: UIImage(systemName: "dollarsign.circle.fill")
        )
    }
    
    override func start() {
        let livePricesViewController = makeLivePricesViewController()
        rootNavigationController.pushViewController(livePricesViewController, animated: false)
    }
    
    override func reloadData() {
        super.reloadData()
    }
}

extension LivePricesCoordinator {
    func makeLivePricesViewController() -> UIHostingController<LivePricesView> {
        let viewModel = container.makeLivePricesViewModel()
        let livePricesViewController = UIHostingController(rootView: LivePricesView(viewModel: viewModel))
        subscribeToLivePricesViewControllerPublishers(livePricesViewController)
        
        container.viewModel = viewModel
        
        return livePricesViewController
    }
    
    func makeEditPortfolioViewController() -> UIHostingController<EditPortfolioView> {
        let viewModel = container.makeEditPortfolioViewModel()
        return UIHostingController(rootView: EditPortfolioView(viewModel: viewModel))
    }
}

private extension LivePricesCoordinator {
    func subscribeToLivePricesViewControllerPublishers(_ viewController: UIHostingController<LivePricesView>) {
        let viewModel = viewController.rootView.viewModel
        viewModel.showEditPortfolioScreenSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showEditPortfolioScreen()
            }
            .store(in: &viewModel.subscriptions)
    }
    
    func showEditPortfolioScreen() {
        let editPortfolioViewController = makeEditPortfolioViewController()
        editPortfolioViewController.modalPresentationStyle = .pageSheet
        rootNavigationController.present(editPortfolioViewController, animated: true)
    }
}
