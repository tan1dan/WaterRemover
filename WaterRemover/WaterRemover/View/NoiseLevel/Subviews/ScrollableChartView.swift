//
//  NoiseData.swift
//  WaterRemover
//
//  Created by Иван Знак on 29/07/2025.
//


import SwiftUI
import Charts

class NoiseData: ObservableObject {
    @Published var values: [Double] = []
    init() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if self.values.count >= 20 {
                return // стоп
            }
            DispatchQueue.main.async {
                self.values.append(Double.random(in: 0...120))
            }
        }
    }
}

struct ScrollableChartView: View {
    @ObservedObject var data = NoiseData()
    @State private var visibleLength: Double = 8
    @State private var visibleXStart: Double = 0
    @State private var visibleXEnd: Double = 8
    @State private var visibleYStart: Double = 0
    @State private var visibleYEnd: Double = 120
    var body: some View {
        let chartValues = Array(data.values.enumerated())
        
        VStack(alignment: .leading) {
            Text("Noise Graphic")
                .font(.gilroy(size: 16, weight: .bold))
                .foregroundStyle(Color.text)
                .padding(.bottom, 11)

            Chart {
                ForEach(chartValues, id: \.0) { index, value in
                    LineMark(
                        x: .value("Index", Double(index)),
                        y: .value("Noise", value)
                    )
                    .foregroundStyle(Color.customBlue)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartXScale(domain: visibleXStart...visibleXEnd)
            .chartXVisibleDomain(length: 8)
//            .chartYScale(domain: visibleYStart...visibleYEnd) // весь доступный диапазон
//            .chartYVisibleDomain(length: 120) // 110 - 40 = 70
            .chartYAxis {
                AxisMarks(position: .leading, values: Array(stride(from: 0, through: 120, by: 10))) { value in
                    AxisGridLine().foregroundStyle(Color.gray.opacity(0.3))
                    AxisValueLabel().foregroundStyle(Color.gray)
                }
            }
            .chartXAxis(.hidden)
            .frame(height: 226)
            .padding()
            .background(.white)
            .cornerRadius(24)
            .onReceive(data.$values) { values in
                let count = Double(values.count)
                if count > 8 {
                    visibleXStart = count - 8
                    visibleXEnd = count
                } else {
                    visibleXStart = 0
                    visibleXEnd = 8
                }
                
                if count == 20 {
                    visibleXStart = 0
                    visibleYStart = 0
                    visibleYEnd = 120
                }
            }
        }
    }
}
