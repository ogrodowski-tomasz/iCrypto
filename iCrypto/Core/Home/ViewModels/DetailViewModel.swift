//
//  DetailViewModel.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 27/04/2022.
//

import Combine
import Foundation

class DetailViewModel: ObservableObject {

    @Published var overviewStatistics: Array<StatisticModel> = []
    @Published var additionalStatistics: Array<StatisticModel> = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil


    @Published var coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()

    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }

    private func addSubscribers() {

        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] downloadedArrays in
                self?.overviewStatistics = downloadedArrays.overview
                self?.additionalStatistics = downloadedArrays.additional
            }
            .store(in: &cancellables)

        coinDetailService.$coinDetails
            .sink { [weak self] downloadedCoinDetails in
                self?.coinDescription = downloadedCoinDetails?.readableDescription
                self?.websiteURL = downloadedCoinDetails?.links?.homepage?.first
                self?.redditURL = downloadedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }

    private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: Array<StatisticModel>, additional: Array<StatisticModel>) {

        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel)

        return (overviewArray, additionalArray)
    }

    func createOverviewArray(coinModel: CoinModel) -> Array<StatisticModel> {
        // OVERVIEW
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)

        let marketCap  = (coinModel.marketCap?.formattedWithAbbreviations() ?? "0,00") + " $"
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)

        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)

        let volume = (coinModel.totalVolume?.formattedWithAbbreviations() ?? "0,00") + " $"
        let volumeStat = StatisticModel(title: "Volume", value: volume)

        let overviewArray: Array<StatisticModel> = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        return overviewArray
    }

    func createAdditionalArray(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) -> Array<StatisticModel> {
        // ADDITIONAL
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)

        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)

        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)

        let marketCapChange = (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "") + " $"
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)

        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)

        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorythm", value: hashing)

        let additionalArray: Array<StatisticModel> = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]

        return additionalArray
    }
}
