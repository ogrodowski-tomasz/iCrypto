//
//  SettingsView.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 27/04/2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss

    let defaultURL = URL(string: "https://www.google.com")!
    let twitterURL = URL(string: "https://twitter.com/tomaszinioo")!
    let instagramURL = URL(string: "https://www.instagram.com/tomaszinio/")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let githubURL = URL(string: "https://github.com/ogrodowski-tomasz")!

    var body: some View {
        NavigationView {
            List {
                personalSection
                goingeckoSection
                developerSection
                applicationSection
            }
            .font(.headline)
            .accentColor(Color.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        XMarkButton()
                    }
                }
            }
        }
    }
}

extension SettingsView {

    private var personalSection: some View {
        Section(header: Text("Personal info")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by Ogrodowski Tomasz. It uses MVVM Architecture, Combine and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Follow me on twitter 🦅", destination: twitterURL)
            Link("Follow me on instagram! 📷", destination: instagramURL)
        }
    }

    private var goingeckoSection: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGecko 🐊", destination: coingeckoURL)
        }
    }

    private var developerSection: some View {
        Section(header: Text("Developer")) {
            VStack(alignment: .leading) {
                Image("ferrari-spider")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Tomasz Ogrodowski. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, data persistance. Motivation to learning Swift programming is this BEAUTIFUL Ferrari that you see above!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit my GitHub 🦦", destination: githubURL)
        }
    }

    private var applicationSection: some View {
        Section(header: Text("Application")) {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)

        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
