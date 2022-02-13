//
//  NetworkService.swift
//  CryptoApp
//
//  Created by Danil on 12.02.2022.
//

import Foundation
import Combine

class NetworkService {
    static let baseLink = "https://api.coingecko.com"
    static let apiVersion = "/api/v3/"
    static var baseURL: URL { URL(string: "\(baseLink)\(apiVersion)") ?? URL(fileURLWithPath: "") }
    
    public typealias Parameters = [String: Any]
    
    func fetchDataPublisher(from url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap({ try self.handleURLResponse(output: $0, url: url) })
            .eraseToAnyPublisher()
    }
}

private extension NetworkService {
    enum NetworkingError: LocalizedError {
        case badURLResponse(URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(let url):
                return "Bad response from URL: \(url)"
            case .unknown:
                return "Uknown error occured"
            }
        }
    }
    
    func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  throw NetworkingError.badURLResponse(url)
              }
        return output.data
    }
}
