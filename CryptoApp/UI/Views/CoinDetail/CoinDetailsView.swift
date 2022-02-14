//
//  CoinDetailView.swift
//  CryptoApp
//
//  Created by Danil on 14.02.2022.
//

import SwiftUI

struct CoinDetailsView: View {
    @ObservedObject var viewModel: CoinDetailsViewModel
    
    init(viewModel: CoinDetailsViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text(viewModel.coin.name)
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailsView(viewModel: CoinDetailsViewModel(coin: dev.coin,
                                                        repository: CoinDetailsRepository(networkService: CoinDetailsNetworkService())))
    }
}
