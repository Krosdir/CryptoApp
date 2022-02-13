//
//  Color.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Foundation
import SwiftUI

struct ColorTheme {
    let accent = Color("accentColor")
    let background = Color("backgroundColor")
    let green = Color("greenColor")
    let red = Color("redColor")
    let secondaryText = Color("secondaryTextColor")
}

extension Color {
    static let theme = ColorTheme()
}
