//
//  PortfolioDataService.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 26/04/2022.
//

import CoreData
import Foundation

class PortfolioDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"

    @Published var savedEntities: Array<PortfolioEntity> = []

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
            self.getPortfolio()
        }
    }

    // MARK: PUBLIC

    func updatePortfolio(coin: CoinModel, amount: Double) {
        // check if coin is already in portfolio
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {

            if amount > 0 { // when we set new value that is greater than 0
                update(entity: entity, amount: amount)
            } else { // when we set a new value to be 0
                delete(entity: entity)
            }
        } else { // when we dont have coins of that type
            add(coin: coin, amount: amount)
        }
    }

    // MARK: PRIVATE

    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio entities: \(error)")
        }
    }

    /// Convert coin from allCoins array into PortfolioEntity type
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }

    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }

    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }

    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving data: \(error)")
        }
    }

    private func applyChanges() {
        save()
        getPortfolio()
    }
}
