//
//  LaunchView.swift
//  CryptoApp
//
//  Created by Danil on 19.02.2022.
//

import SwiftUI

struct LaunchView: View {
    @StateObject var viewModel: LaunchViewModel
    
    init(viewModel: LaunchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            Image(systemName: "bitcoinsign.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .upLeftShadow()
            
            ZStack {
                if viewModel.isTextShown {
                    HStack(spacing: 0) {
                        ForEach(viewModel.loadingText.indices) { index in
                            Text(viewModel.loadingText[index])
                                .font(.headline)
                                .foregroundColor(.theme.accent)
                                .fontWeight(.heavy)
                                .offset(y: viewModel.letterCounter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y: 80)
        }
        .navigationBarHidden(true)
        .onAppear(perform: showLoadingText)
        .onReceive(viewModel.timer) { _ in
            withAnimation(.spring()) { updateTextAnimation() }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(viewModel: LaunchViewModel())
            .preferredColorScheme(.dark)
    }
}

private extension LaunchView {
    func showLoadingText() {
        viewModel.showText()
    }
    
    func updateTextAnimation() {
        viewModel.updateTextAnimation()
    }
}
