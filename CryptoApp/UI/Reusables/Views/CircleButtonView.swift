//
//  CircleButtonView.swift
//  CryptoApp
//
//  Created by Danil on 05.01.2022.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    @Binding var isRotated: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Image(systemName: iconName)
                .font(.headline)
                .foregroundColor(.theme.accent)
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: isRotated ? 180 : 0))
        })
            .buttonStyle(NeumorphicButtonStyle(width: 50, height: 50))
            .padding(.horizontal)
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButtonView(
                iconName: "info",
                isRotated: .constant(false),
                action: {}
            )
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            CircleButtonView(
                iconName: "info",
                isRotated: .constant(false),
                action: {}
            )
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
