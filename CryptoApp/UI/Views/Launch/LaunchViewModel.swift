//
//  LaunchViewModel.swift
//  CryptoApp
//
//  Created by Danil on 19.02.2022.
//

import Combine
import Foundation

class LaunchViewModel: ObservableObject {
    @Published var isTextShown = false
    @Published var letterCounter = 0
    
    var loadingText = "Loading your portfolio...".map { String($0) }
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    init() {
        
    }
    
    func showText() {
        isTextShown.toggle()
    }
    
    func updateTextAnimation() {
        let lastIndex = loadingText.count - 1
        if letterCounter == lastIndex + 5 {
            letterCounter = 0
        } else {
            letterCounter += 1
        }
    }
}
