//
//  LivePricesView.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import SwiftUI

struct LivePricesView: View {
    @ObservedObject var viewModel: LivePricesViewModel
    @State private var showPortfolio = false
    
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
                columnTitles
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                if showPortfolio {
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
        LivePricesView(viewModel: LivePricesViewModel(repository: LivePricesRepository(networkService: LivePricesNetworkService())))
    }
}

private extension LivePricesView {
    var homeHeader: some View {
        HStack {
            CircleButtonView(
                iconName: "plus",
                isRotated: .constant(false),
                action: didTapEditPortfolio)
                .opacity(showPortfolio ? 1 : 0)
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(
                iconName: "chevron.right",
                isRotated: $showPortfolio,
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
                CoinRowView(coin: coin, showHoldingsCulums: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
    
    func didTapShowPortfolio() {
        withAnimation(.spring()) {
            showPortfolio.toggle()
        }
    }
    
    func didTapEditPortfolio() {
        viewModel.didTapEditPortfolio()
    }
    
    func didTapCoinRow(with coin: Coin) {
        viewModel.didTapCoinRow(with: coin)
    }
}
