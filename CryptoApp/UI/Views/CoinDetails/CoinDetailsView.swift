//
//  CoinDetailView.swift
//  CryptoApp
//
//  Created by Danil on 14.02.2022.
//

import SwiftUI

struct CoinDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CoinDetailsViewModel
    @State var isDescriptionExpanded = false
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
            
            VStack {
                detailsHeader
                ScrollView {
                    VStack(spacing: 50) {
                        ChartView(coin: viewModel.coin)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.theme.background)
                                    .padding(-16)
                                    .upLeftShadow(radius: 8)
                            )
                        overviewCard
                        additionalCard
                    }
                    .padding(.top, 4)
                    .padding(32)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoinDetailsView(viewModel: CoinDetailsViewModel(coin: dev.coin,
                                                            repository: CoinDetailsRepository(networkService: CoinDetailsNetworkService())))
        }
        .preferredColorScheme(.dark)
    }
}

private extension CoinDetailsView {
    var overviewCard: some View {
        VStack {
            overviewTitle
            Divider()
            descriptionSection
            overviewGrid
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.theme.background)
                .padding(-16)
                .upLeftShadow(radius: 8)
        )
    }
    
    var additionalCard: some View {
        VStack {
            additionalTitle
            Divider()
            additionalGrid
            linksSection
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.theme.background)
                .padding(-16)
                .upLeftShadow(radius: 8)
        )
    }
    
    var detailsHeader: some View {
        HStack {
            CircleButtonView(
                iconName: "chevron.right",
                isRotated: .constant(true),
                action: didTapBackButton
            )
            Spacer()
            Text(viewModel.coin.name)
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
            Spacer()
            navigationBarTrailingItems
                .padding(.trailing, 16)
        }
        .padding(.top)
        .padding(.horizontal)
    }
    
    var navigationBarTrailingItems: some View {
        HStack {
            Text(viewModel.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.secondaryText)
            CoinImageView(coin: viewModel.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    var descriptionSection: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(height: 95)
            } else {
                ZStack {
                    if let description = viewModel.description,
                       !description.isEmpty {
                        VStack(alignment: .leading) {
                            Text(description)
                                .lineLimit(isDescriptionExpanded ? nil : 3)
                                .font(.callout)
                                .foregroundColor(.theme.secondaryText)
                            
                            Button(action: didTapExpandButton) {
                                Text(isDescriptionExpanded ? "Read less" : "Read more...")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 4)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
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
    
    var linksSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteLink = viewModel.websiteLink,
               let url = URL(string: websiteLink) {
                Link("Website", destination: url)
            }
            
            if let redditLink = viewModel.redditLink,
               let url = URL(string: redditLink) {
                Link("Reddit", destination: url)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
    func didTapBackButton() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func didTapExpandButton() {
        withAnimation(.easeInOut) {
            isDescriptionExpanded.toggle()
        }
    }
}
