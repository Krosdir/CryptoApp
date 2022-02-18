//
//  NeumorphicButtonStyle.swift
//  CryptoApp
//
//  Created by Danil on 18.02.2022.
//

import SwiftUI

struct NeumorphicButtonStyle: ButtonStyle {
    let width: CGFloat
    let height: CGFloat

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .opacity(configuration.isPressed ? 0.2 : 1)
        .frame(width: width, height: height)
        .background(
          Group {
            if configuration.isPressed {
              Capsule()
                .fill(Color.theme.background)
                .downRightShadow()
            } else {
              Capsule()
                .fill(Color.theme.background)
                .upLeftShadow()
            }
          }
        )
    }
}
