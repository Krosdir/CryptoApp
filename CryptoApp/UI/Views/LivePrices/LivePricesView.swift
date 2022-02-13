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
            if showPortfolio {
                CircleButtonView(iconName: "plus")
                    .onTapGesture(perform: didTapEditPortfolio)
            } else {
                Spacer()
                Spacer()
            }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0 ))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsCulums: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
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
    
    func didTapEditPortfolio() {
        viewModel.didTapEditPortfolio()
    }
}
