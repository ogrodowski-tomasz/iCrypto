//
//  NetworkingManager.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 25/04/2022.
//

import Combine
import Foundation

class NetworkingManager {

    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown

        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                return "[🔥] Bad response from URL: \(url)"
            case .unknown:
                return "[‼️] Unknown error occured."
            }
        }
    }

    // By setting this func as 'static' we dont have to init NetworkingManager class to have access to this method.
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            // .subscribe(on: DispatchQueue.global(qos: .default)) [dataTaskPublisher will already be on the background thread so we dont have to call that]
             .tryMap({ try handleURLResponse(output: $0, url: url)})
             .retry(3)
             .eraseToAnyPublisher() // now we can return any type of publihser with <Data> and <Error>
    }

    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
           response.statusCode >= 200 && response.statusCode < 300
        else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }

    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print("Failed completion: \(error.localizedDescription)")
        }
    }
}
