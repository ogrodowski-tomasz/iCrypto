//
//  HomeViewModel.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 19/04/2022.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {

    @Published var statistics: Array<StatisticModel> = []

    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings

    @Published var searchText: String = ""

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>() // we wont cancel that sub so we can put it into set

    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }

    init() {
        addSubscribers()
    }

    func addSubscribers() {

        // Subscribing to text in TextField to filter the view.
        // Combining publishers in subscription to look for changes in both of them.
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] filteredCoins in
                self?.allCoins = filteredCoins
            }
            .store(in: &cancellables)

        // Updates portfolioCoins
        /*
        // PortfolioEntity is not the same as CoinModel. We want to convert PortoflioEntity type
        // with CoinModel type (we want to subscribe to something that contains all  of the CoinModels in our app.)
        // We want to use allCoins instead of coinDataService.$allCoins because in hVM we have the array of coins FILTERED! so that we can use it with search bar because we want to filter out portfolio list as well.
        */
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
        // After mapping we want to sink that coins into portfolioCoins array.
            .sink { [weak self] returnedCoinsFromCoreData in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoinsFromCoreData)
            }
            .store(in: &cancellables)

        // Updates marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)

    }

    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }

    private func filterAndSortCoins(text: String, coins: Array<CoinModel>, sort: SortOption) -> Array<CoinModel> {
        var updatedCoins = filterCoins(textInTextField: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins) //& means that we will be changing this value (usage of inout)
        return updatedCoins
    }

    private func filterCoins(textInTextField: String, coins: [CoinModel]) -> [CoinModel] {
        guard !textInTextField.isEmpty else {
            return coins
        }

        let lowercasedText = textInTextField.lowercased()
        return coins.filter { coin in
              return coin.name.lowercased().contains(lowercasedText)
                || coin.symbol.lowercased().contains(lowercasedText)
                || coin.id.lowercased().contains(lowercasedText)
        }
    }

    private func sortCoins(sort: SortOption, coins: inout Array<CoinModel>) { // inout means that we are taking an array, sorting and returning the same one but sorted. using -> means that we would creat a new array. It is more efficent.
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }

    private func sortPortfolioCoinsIfNeeded(coins: Array<CoinModel>) -> Array<CoinModel> {
        // will only sort by holdings or reversed holdings if needed (because we are sorting by other values before)
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }

    private func mapAllCoinsToPortfolioCoins(allCoins: Array<CoinModel>, portfolioEntities: Array<PortfolioEntity>) -> Array<CoinModel> {
        // Mapping
        /* Now we want to map coins from allCoins into portfolioCoins
        // inside allCoins we are looking for coin.ids which match coinIDs from PortfolioEntities
         Using compact Map because we can have nil value of certain coin and so we dont want that coin to be included in portfolioCoins */
        allCoins
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                // updating holdings of our portfolio by the amount got from Core Data
                // it returns the CoinModel with the amount of certain coin in our portfolio.
                return coin.updateHoldings(amount: entity.amount)
            }
    }

    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: Array<CoinModel>) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)



        let portfolioValue =
        portfolioCoins
            .map { $0.currentHoldingsValue } // getting an array of Double
            .reduce(0, +) // starting from 0 ans summing up every value in array

        let previousValue =
        portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100 // 25% -> 25 so we have to divide by 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)

        let percentageChange = ((portfolioValue - previousValue) / previousValue)

        let portfolio = StatisticModel(
            title: "Portfolio value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange
        )
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }
}
