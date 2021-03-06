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
    
    weak var container: LivePricesContainer?
    
    public override init(
        root: UINavigationController,
        parent: Coordinator?
    ) {
        super.init(root: root, parent: parent)
        
        rootNavigationController.tabBarItem = UITabBarItem(
            title: "Live Prices".uppercased(),
            image: UIImage(systemName: "dollarsign.circle"),
            selectedImage: UIImage(systemName: "dollarsign.circle.fill")
        )
    }
    
    override func start() {
        let livePricesViewController = makeLivePricesViewController() ?? UIViewController()
        rootNavigationController.pushViewController(livePricesViewController, animated: false)
    }
    
    override func reloadData() {
        super.reloadData()
    }
}

extension LivePricesCoordinator {
    func makeLivePricesViewController() -> UIHostingController<LivePricesView>? {
        guard let viewModel = container?.makeLivePricesViewModel() else { return nil }
        subscribeToLivePricesViewModelPublishers(viewModel)
        let livePricesViewController = UIHostingController(rootView: LivePricesView(viewModel: viewModel))
        
        return livePricesViewController
    }
    
    func makeEditPortfolioViewController(with coins: [Coin]) -> UIHostingController<EditPortfolioView>? {
        guard let viewModel = container?.makeEditPortfolioViewModel(with: coins) else { return nil }
        return UIHostingController(rootView: EditPortfolioView(viewModel: viewModel))
    }
    
    func makeCoinDetailsViewController(for coin: Coin) -> UIHostingController<CoinDetailsView>? {
        guard let viewModel = container?.makeCoinDetailsViewModel(for: coin) else { return nil }
        return UIHostingController(rootView: CoinDetailsView(viewModel: viewModel))
    }
}

private extension LivePricesCoordinator {
    func subscribeToLivePricesViewModelPublishers(_ viewModel: LivePricesViewModel) {
        viewModel.showEditPortfolioScreenSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                self?.showEditPortfolioScreen(with: coins)
            }
            .store(in: &viewModel.subscriptions)
        
        viewModel.showCoinDetailsScreenSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coin in
                self?.showCoinDetailsScreen(for: coin)
            }
            .store(in: &viewModel.subscriptions)
        
        viewModel.hideLaunchScreenSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.parent?.pop(animated: true)
            }
            .store(in: &viewModel.subscriptions)
    }
    
    func showEditPortfolioScreen(with coins: [Coin]) {
        let editPortfolioViewController = makeEditPortfolioViewController(with: coins) ?? UIViewController()
        editPortfolioViewController.modalPresentationStyle = .pageSheet
        rootNavigationController.present(editPortfolioViewController, animated: true)
    }
    
    func showCoinDetailsScreen(for coin: Coin) {
        let coinDetailsViewController = makeCoinDetailsViewController(for: coin) ?? UIViewController()
        rootNavigationController.pushViewController(coinDetailsViewController, animated: true)
    }
}
