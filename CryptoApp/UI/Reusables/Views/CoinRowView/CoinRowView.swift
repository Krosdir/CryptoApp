//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import SwiftUI

struct CoinRowView: View {
    @ObservedObject var viewModel: CoinRowViewModel
    
    init(coin: Coin, showHoldingsCulums: Bool) {
        let wrappedViewModel = CoinRowViewModel(coin: coin, showHoldingsCulums: showHoldingsCulums)
        _viewModel = ObservedObject(wrappedValue: wrappedViewModel)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if viewModel.showHoldingsCulums {
                middleColumn
            }
            rightColumn
        }
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, showHoldingsCulums: true)
    }
}

private extension CoinRowView {
    var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(viewModel.coin.rank)")
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: viewModel.coin)
                .frame(width: 30, height: 30)
            Text(viewModel.coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(.theme.accent)
        }
    }
    
    var rightColumn: some View {
        VStack (alignment: .trailing){
            Text(viewModel.coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(.theme.accent)
            Text((viewModel.coin.priceChangePercentage24H ?? 0).asPersantageString())
                .foregroundColor(
                    (viewModel.coin.priceChangePercentage24H ?? 0) >= 0 ?
                        .theme.green :
                            .theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
    
    var middleColumn: some View {
        VStack (alignment: .trailing){
            Text(viewModel.coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((viewModel.coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(.theme.accent)
    }
}
