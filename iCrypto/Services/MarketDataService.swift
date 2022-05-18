//
//  MarketDataService.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 25/04/2022.
//

import Combine
import Foundation

class MarketDataService {

    @Published var marketData: MarketDataModel? = nil

    var marketDataSubscription: AnyCancellable?

    init() {
        getData()
    }

    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }

        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] downloadedGlobalData in
                self?.marketData = downloadedGlobalData.data
                // because we want to only download it once per request
                // we can cancel it after appending downloadedCoins
                self?.marketDataSubscription?.cancel()
            })
    }
}
