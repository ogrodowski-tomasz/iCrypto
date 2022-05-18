//
//  CoinImageService.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 25/04/2022.
//

import Combine
import Foundation
import SwiftUI

class CoinImageService {

    @Published var image: UIImage? = nil

    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String

    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImageFromFM()
    }

    private func getCoinImageFromFM() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }

    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else {
            print("Invalid coin image's url")
            return
        }

        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion:
                    NetworkingManager.handleCompletion,
                  receiveValue: { [weak self] downloadedImage in
                guard let self = self, let downloadedImage = downloadedImage else { return }
                self.image = downloadedImage
                // because we want to only download it once per request
                // we can cancel it after appending downloadedCoins
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, folderName: self.folderName, imageName: self.imageName)
            })
    }
}
