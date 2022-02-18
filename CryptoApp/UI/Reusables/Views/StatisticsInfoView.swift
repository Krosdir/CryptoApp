//
//  StatisticsInfoView.swift
//  CryptoApp
//
//  Created by Danil on 15.02.2022.
//

import SwiftUI

struct StatisticsInfoView: View {
    let stats: StatisticsInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stats.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stats.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (stats.percentageChange ?? 0) >= 0 ? 0 : 180)
                    )
                
                Text(stats.percentageChange?.asPersantageString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor(
                (stats.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red
            )
            .opacity(stats.percentageChange == nil ? 0 : 1)
        }
    }
}

struct StatisticsInfoView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsInfoView(stats: dev.stats)
    }
}
