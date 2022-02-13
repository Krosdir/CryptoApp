//
//  URL.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Foundation

extension URL {
    init?(string: String,
         relativeTo url: URL?,
         parameters: NetworkService.Parameters
    ) {
        func parametersToQueriesString(_ parameters: NetworkService.Parameters) -> String {
            var result = "?"
            parameters.forEach { pair in
                let andSymbol = result.count == 1 ? "" : "&"
                let encodedValue = encodeParameter(pair.value)
                result += "\(andSymbol)\(pair.key)=\(encodedValue)"
            }
            return result
        }
        
        func encodeParameter(_ value: Any) -> String {
            switch value {
            case let concreteValue as String:
                return concreteValue
            default:
                return "\(value)"
            }
        }
        
        let parametersString = parametersToQueriesString(parameters)
        self.init(string: string + parametersString, relativeTo: url)
    }
}
