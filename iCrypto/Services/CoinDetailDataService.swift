//
//  CoinDetailDataService.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 27/04/2022.
//

import Combine
import Foundation

class CoinDetailDataService {
    @Published var coinDetails: CoinDetailModel? = nil
    var coinDetailSubscription: AnyCancellable?

    let coin: CoinModel

    init(coin: CoinModel) {
        self.coin = coin
        getCoinsDetails()
    }

    func getCoinsDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }

        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] downloadedCoinDetails in
                self?.coinDetails = downloadedCoinDetails
                // because we want to only download it once per request
                // we can cancel it after appending downloadedCoins
                self?.coinDetailSubscription?.cancel()
            })
    }
}
