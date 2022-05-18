//
//  CoinDataService.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 19/04/2022.
//

import Combine
import Foundation

class CoinDataService {
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?

    init() {
        getCoins()
    }

    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }

        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main) // going back on main thread AFTER decoding
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] downloadedCoins in
                self?.allCoins = downloadedCoins
                // because we want to only download it once per request
                // we can cancel it after appending downloadedCoins
                self?.coinSubscription?.cancel()
            })
    }
}
