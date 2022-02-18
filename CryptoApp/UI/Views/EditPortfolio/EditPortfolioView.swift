//
//  EditPortfolioView.swift
//  CryptoApp
//
//  Created by Danil on 13.02.2022.
//

import SwiftUI

struct EditPortfolioView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: EditProfileViewModel
    @State private var selectedCoin: Coin?
    @State private var quantityText = ""
    @State private var showCheckmark = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        SearchBarView(searchText: $viewModel.searchText)
                        coinLogoList
                        
                        if selectedCoin != nil {
                            portfolioInputSection
                        }
                    }
                }
                .navigationTitle("Edit Portfolio")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        closeButton
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        trailingNavBarButtons
                    }
                }
            }
        }
    }
}

struct EditPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        EditPortfolioView(viewModel: EditProfileViewModel())
    }
}

private extension EditPortfolioView {
    var closeButton: some View {
        Button(action: didTapClose) {
            Image(systemName: "xmark")
                .font(.headline)
                .foregroundColor(.theme.accent)
        }
    }
    
    var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.filteredCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture { didChooseCoin(coin) }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ?
                                        Color.theme.accent : Color.clear, lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.horizontal)
        }
    }
    
    var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.7", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrenValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none, value: selectedCoin)
        .padding()
        .font(.headline)
    }
    
    var trailingNavBarButtons: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .foregroundColor(.theme.accent)
                .opacity(showCheckmark ? 1 : 0)
            
            Button(action: didTapSaveButton) {
                Text("Save".uppercased())
            }
            .foregroundColor(.theme.accent)
            .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1 : 0
            )
        }
        .font(.headline)
    }
    
    func didChooseCoin(_ coin: Coin) {
        withAnimation(.easeIn) {
            selectedCoin = coin
        }
    }
    
    func didTapClose() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func getCurrenValue() -> Double {
        guard let quantity = Double(quantityText) else { return 0 }
        
        return quantity * (selectedCoin?.currentPrice ?? 0)
    }
    
    func didTapSaveButton() {
        guard let coin = selectedCoin else { return }
        
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeIn) {
                showCheckmark = false
            }
        }
    }
    
    func removeSelectedCoin() {
        selectedCoin = nil
        viewModel.searchText = ""
    }
}
