//
//  MarketDataModel.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 25/04/2022.
//

import Foundation

// JSON Data:
/*
 URL: https://api.coingecko.com/api/v3/global

 JSON Response:
 {
   "data": {
     "active_cryptocurrencies": 13690,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 794,
     "total_market_cap": {
       "btc": 48734287.636072755,
       "eth": 660810689.3927181,
       "ltc": 18635150743.472397,
       "bch": 6174925753.477006,
       "bnb": 4818655334.922542,
       "eos": 822724808585.3297,
       "xrp": 2843474986425.6943,
       "xlm": 10336632446250.525,
       "link": 146358560593.84253,
       "dot": 108434322439.00465,
       "yfi": 103822864.8244848,
       "usd": 1891488918073.3784,
       "aed": 6947627944975.352,
       "ars": 216938646991671.97,
       "aud": 2648901608515.341,
       "bdt": 163094375316021.9,
       "bhd": 713127260403.1066,
       "bmd": 1891488918073.3784,
       "brl": 9200769544184.344,
       "cad": 2414966042105.8594,
       "chf": 1808061016363.918,
       "clp": 1608805899267312.5,
       "cny": 12410626238154.863,
       "czk": 43083702818576.836,
       "dkk": 13121338067209.594,
       "eur": 1763728299102.1143,
       "gbp": 1485951802549.5298,
       "hkd": 14843099901686.42,
       "huf": 659570345615378,
       "idr": 27322231082986944,
       "ils": 6223110138307.564,
       "inr": 145088726749695.25,
       "jpy": 241552804564362.47,
       "krw": 2370483189802672.5,
       "kwd": 578228162255.0316,
       "lkr": 643109271767640.8,
       "mmk": 3502112710316456,
       "mxn": 38477931086046,
       "myr": 8240271471586.681,
       "ngn": 784173475654860.4,
       "nok": 17262032396053.475,
       "nzd": 2869729156722.5703,
       "php": 99022270745584.97,
       "pkr": 353566566010866.8,
       "pln": 8193192312415.816,
       "rub": 140820411772059.72,
       "sar": 7095495091145.725,
       "sek": 18313728606836.04,
       "sgd": 2599206520170.7993,
       "thb": 64455477218818.89,
       "try": 27948347072669.98,
       "twd": 55478945577360.77,
       "uah": 57217901046103.34,
       "vef": 189394785366.68735,
       "vnd": 43477507022667416,
       "zar": 29760679071010.87,
       "xdr": 1366073017899.8745,
       "xag": 80271990279.43573,
       "xau": 998214361.6240458,
       "bits": 48734287636072.76,
       "sats": 4873428763607275
     },
     "total_volume": {
       "btc": 2487053.658964706,
       "eth": 33723107.952452436,
       "ltc": 951006408.2193842,
       "bch": 315124575.2005816,
       "bnb": 245910117.15411335,
       "eos": 41986060426.142944,
       "xrp": 145110869824.84366,
       "xlm": 527508676002.31384,
       "link": 7469106686.527054,
       "dot": 5533721563.617741,
       "yfi": 5298385.3539454555,
       "usd": 96528228127.90126,
       "aed": 354557834736.59546,
       "ars": 11071015540445.254,
       "aud": 135181219573.6132,
       "bdt": 8323184405921.943,
       "bhd": 36392976040.553185,
       "bmd": 96528228127.90126,
       "brl": 469542260082.55054,
       "cad": 123242801375.21051,
       "chf": 92270657569.86403,
       "clp": 82102084434186.44,
       "cny": 633350663215.5989,
       "czk": 2198687739869.1433,
       "dkk": 669620372708.8329,
       "eur": 90008228959.00229,
       "gbp": 75832479489.05121,
       "hkd": 757486929870.3617,
       "huf": 33659809570975.234,
       "idr": 1394333601292336.2,
       "ils": 317583565706.25385,
       "inr": 7404303340432.258,
       "jpy": 12327148206436.693,
       "krw": 120972710932769.34,
       "kwd": 29508679338.69941,
       "lkr": 32819752684349.074,
       "mmk": 178723084973387.62,
       "mxn": 1963641697434.1604,
       "myr": 420525225839.2023,
       "ngn": 40018672817265.266,
       "nok": 880932150939.9563,
       "nzd": 146450697151.08932,
       "php": 5053396955668.454,
       "pkr": 18043539042807.973,
       "pln": 418122638241.09784,
       "rub": 7186478706121.101,
       "sar": 362103928970.4934,
       "sek": 934603293702.491,
       "sgd": 132645133436.00887,
       "thb": 3289352081115.1406,
       "try": 1426286136942.5115,
       "twd": 2831253339005.3657,
       "uah": 2919997337760.601,
       "vef": 9665371482.446753,
       "vnd": 2218784723619331.8,
       "zar": 1518774755251.4863,
       "xdr": 69714713446.76103,
       "xag": 4096515139.970516,
       "xau": 50941807.11221867,
       "bits": 2487053658964.706,
       "sats": 248705365896470.62
     },
     "market_cap_percentage": {
       "btc": 39.031784237921556,
       "eth": 18.259985671136175,
       "usdt": 4.390705049140095,
       "bnb": 3.493149078922294,
       "usdc": 2.6339251357510904,
       "sol": 1.7081102231343772,
       "xrp": 1.6920743169382837,
       "luna": 1.652545899664957,
       "ada": 1.4498988843752827,
       "dot": 1.0208159897515925
     },
     "market_cap_change_percentage_24h_usd": -2.3352253211015994,
     "updated_at": 1650895624
   }
 }
 */

struct GlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }

    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "\(item.value.formattedWithAbbreviations()) $"
        }
        return ""
    }

    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "\(item.value.formattedWithAbbreviations()) $"
        }
        return ""
    }

    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }
}
