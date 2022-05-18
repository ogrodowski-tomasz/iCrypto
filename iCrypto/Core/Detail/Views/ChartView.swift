//
//  ChartView.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 27/04/2022.
//

import SwiftUI

struct ChartView: View {

    private let data: Array<Double>
    private let maxY: Double // highest price in array
    private let minY: Double // lowest price in array
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date

    @State private var percentage: CGFloat = 0

    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0

        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red

        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60) // week before
    }

    // EXAMPLE AND EXPLANATION OF MATH
    /*
     // X AXIS
    // width of the geometry (f.ex. frame): 300
    // items in data array: 100
    // Space for each element from array: 300/100 = 3
    // x coordinate for first element: 3*(0+1) = 3
    // x coordinate for second element: 3*(1+1) = 6
    // x coordinate for third element: 3*(2+1) = 9
    //...
    // x coordinate for last(100th) element: 3*(99+1) = 300

     // Y AXIS
     // 60,000 - max value in data array
     // 50,000 - min value in data array
     // max - min = 60k - 50k = 10k - range of yAxis
     // EXAMPLE: bitcoin value is 52k (it is our data point on graph): where should this point be put?
     // We have to check how far from the min point this value is:
     // 52k - 50k = 2k
     // What part of the range is that difference?
     // 2k / 10k = 0,2 (it is 20%)
     // this 52k point have to be 20% of view above the lowest point
     */

    // MARK: IMPORTANT
    // the (0,0) point is on the UPPER LEFT corner of the screen so we have to substract the percent value of the height of the Chart (yPosition) from 1

    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartYAxis.padding(.horizontal, 4)
                         , alignment: .leading)
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

extension ChartView {

    private var chartView: some View {
        GeometryReader { geometry in // so that our view's size can be dynamic
            Path { path in
                for index in data.indices { // indexes of data Array

                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1) // setting an equal space for each item in data array. Substracting it by index+1 (because first index is 0)

                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height


                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)

        }
    }

    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }

    private var chartYAxis: some View {
        VStack {
            Text("$\(maxY.formattedWithAbbreviations())")
            Spacer()
            Text("$\(((maxY - minY)/2).formattedWithAbbreviations())")
            Spacer()
            Text("$\(minY.formattedWithAbbreviations())")
        }
    }

    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}
