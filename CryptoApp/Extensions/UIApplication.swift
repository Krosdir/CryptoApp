//
//  UIApplication.swift
//  CryptoApp
//
//  Created by Danil on 13.02.2022.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
