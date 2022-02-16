//
//  CoinDetailView.swift
//  CryptoApp
//
//  Created by Danil on 14.02.2022.
//

import SwiftUI

struct CoinDetailsView: View {
    @ObservedObject var viewModel: CoinDetailsViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(viewModel: CoinDetailsViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    ChartView(coin: viewModel.coin)
                    
                    overviewTitle
                    Divider()
                    overviewGrid
                    
                    additionalTitle
                    Divider()
                    additionalGrid
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.coin.name)
                        .font(.headline)
                        .foregroundColor(.theme.accent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    navigationBarTrailingItems
                }
            }
        }
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoinDetailsView(viewModel: CoinDetailsViewModel(coin: dev.coin,
                                                            repository: CoinDetailsRepository(networkService: CoinDetailsNetworkService())))
        }
    }
}

private extension CoinDetailsView {
    var navigationBarTrailingItems: some View {
        HStack {
            Text(viewModel.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.secondaryText)
            CoinImageView(coin: viewModel.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: 30,
            pinnedViews: []) {
                ForEach(viewModel.overviewStatistics) { stats in
                    StatisticsInfoView(stats: stats)
                }
            }
    }
    
    var additionalGrid: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else {
                LazyVGrid(
                    columns: columns,
                    alignment: .leading,
                    spacing: 30,
                    pinnedViews: []) {
                        ForEach(viewModel.additionalStatistics) { stats in
                            StatisticsInfoView(stats: stats)
                        }
                    }
            }
        }
    }
}
