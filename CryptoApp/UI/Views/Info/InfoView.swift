//
//  InfoView.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import SwiftUI

struct InfoView: View {
    let appGithubURL = URL(string: "https://github.com/Krosdir/CryptoApp") ?? URL(fileURLWithPath: "")
    let coingeckoURL = URL(string: "https://www.coingecko.com") ?? URL(fileURLWithPath: "")
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                infoHeader
                List {
                    generalSection
                    coinGeckoSection
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

private extension InfoView {
    var infoHeader: some View {
        Text("App Info")
            .font(.headline)
            .fontWeight(.heavy)
            .foregroundColor(.theme.accent)
            .frame(height: 50)
            .padding(.top)
            .padding(.horizontal)
    }
    
    var generalSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image(systemName: "bitcoinsign.square.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made using MVVM-C Architecture, SwiftUI, Combine and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            .padding(.vertical)
            Link(destination: appGithubURL) {
                Text("App Github")
                    .fontWeight(.bold)
            }
        } header: { Text("Krosdir") }
        
    }
    
    var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            .padding(.vertical)
            Link(destination: coingeckoURL) {
                Text("Visit CoinGecko")
                    .fontWeight(.bold)
            }
        } header: { Text("CoinGecko") }
        
    }
}
