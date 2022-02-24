//
//  LivePricesView.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import SwiftUI

struct LivePricesView: View {
    @ObservedObject var viewModel: LivePricesViewModel
    
    init(viewModel: LivePricesViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        viewModel.getCoins()
    }
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                homeHeader
                SearchBarView(searchText: $viewModel.searchText)
                columnTitles
                if !viewModel.isPortfolioShown {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                if viewModel.isPortfolioShown {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct LivePricesView_Previews: PreviewProvider {
    static var previews: some View {
        LivePricesView(viewModel: LivePricesViewModel(repository: LivePricesRepository(networkService: LivePricesNetworkService(), storageService: CoreDataStorageService(context: dev.context))))
    }
}

private extension LivePricesView {
    var homeHeader: some View {
        HStack {
            CircleButtonView(
                iconName: "plus",
                isRotated: .constant(false),
                action: didTapEditPortfolio)
                .opacity(viewModel.isPortfolioShown ? 1 : 0)
            Spacer()
            Text(viewModel.isPortfolioShown ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(
                iconName: "chevron.right",
                isRotated: $viewModel.isPortfolioShown,
                action: didTapShowPortfolio)
        }
        .padding(.top)
        .padding(.horizontal)
    }
    
    var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                Button { didTapCoinRow(with: coin) } label: {
                    CoinRowView(coin: coin, showHoldingsCulums: false)
                        .padding(.horizontal, -10)
                }
                .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(.plain)
    }
    
    var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                Button { didTapCoinRow(with: coin) } label: {
                    CoinRowView(coin: coin, showHoldingsCulums: true)
                        .padding(.horizontal, -10)
                }
                .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(.plain)
    }
    
    var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .sortStyle(for: .rank, and: viewModel.sortOption)
            }
            .onTapGesture { didTapSort(with: .rank) }
            Spacer()
            if viewModel.isPortfolioShown {
                HStack {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .sortStyle(for: .holdings, and: viewModel.sortOption)
                }
                .onTapGesture { didTapSort(with: .holdings) }
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .sortStyle(for: .price, and: viewModel.sortOption)
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture { didTapSort(with: .price) }
            Button(action: didTapReload) {
                Image(systemName: "goforward")
            }
            .rotationEffect(
                Angle(degrees: viewModel.isLoading ? 360 : 0),
                anchor: .center
            )
            .padding(8)
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
    
    func didTapShowPortfolio() {
        withAnimation(.spring()) {
            viewModel.isPortfolioShown.toggle()
        }
    }
    
    func didTapEditPortfolio() {
        viewModel.didTapEditPortfolio()
    }
    
    func didTapCoinRow(with coin: Coin) {
        viewModel.didTapCoinRow(with: coin)
    }
    
    func didTapReload() {
        withAnimation(.linear(duration: 2)) {
            viewModel.getCoins()
        }
    }
    
    func didTapSort(with sort: LivePricesViewModel.SortOptions) {
        withAnimation(.spring()) {
            viewModel.didTapSort(with: sort)
        }
    }
}
