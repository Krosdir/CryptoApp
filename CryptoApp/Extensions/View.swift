//
//  View.swift
//  CryptoApp
//
//  Created by Danil on 18.02.2022.
//

import SwiftUI

extension View {
    /// Simulate shining a light on the northwest edge of a view.
    /// Light shadow on the northwest edge, dark shadow on the southeast edge.
    ///   - parameters:
    ///     - radius: The size of the shadow
    ///     - offset: The value used for (-x, -y) and (x, y) offsets
    func upLeftShadow(
        radius: CGFloat = 12,
        offset: CGFloat = 6
    ) -> some View {
        return self
            .shadow(color: .theme.lightShadow.opacity(0.25),
                    radius: radius, x: -offset, y: -offset)
            .shadow(color: .theme.darkShadow,
                    radius: radius, x: offset, y: offset)
    }
    
    /// Simulate shining a light on the southeast edge of a view.
    /// Light shadow on the southeast edge, dark shadow on the northwest edge.
    ///   - parameters:
    ///     - radius: The size of the shadow
    ///     - offset: The value used for (-x, -y) and (x, y) offsets
    func downRightShadow(
        radius: CGFloat = 12,
        offset: CGFloat = 6
    ) -> some View {
        return self
            .shadow(color: .theme.darkShadow,
                    radius: radius, x: -offset, y: -offset)
            .shadow(color: .theme.lightShadow.opacity(0.25),
                    radius: radius, x: offset, y: offset)
    }
    
    func sortStyle(
        for sort: LivePricesViewModel.SortOptions,
        and viewModelSort: LivePricesViewModel.SortOptions
    ) -> some View {
        var reversedSort: LivePricesViewModel.SortOptions = .rankReversed
        switch sort {
        case .rank: reversedSort = .rankReversed
        case .holdings: reversedSort = .holdingsReversed
        case .price: reversedSort = .priceReversed
        default: break
        }
        return self
            .opacity((viewModelSort == sort || viewModelSort == reversedSort) ? 1 : 0)
            .rotationEffect(Angle(degrees: viewModelSort == sort ? 0 : 180))
    }
}
