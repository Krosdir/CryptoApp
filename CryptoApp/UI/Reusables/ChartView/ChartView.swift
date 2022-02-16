//
//  ChartView.swift
//  CryptoApp
//
//  Created by Danil on 16.02.2022.
//

import SwiftUI

struct ChartView: View {
    @StateObject var viewModel: ChartViewModel
    @State private var percentage: CGFloat = 0
    
    private let lineColor: Color
    
    init(coin: Coin) {
        let wrappedViewModel = ChartViewModel(coin: coin)
        _viewModel = StateObject(wrappedValue: wrappedViewModel)
        
        lineColor = wrappedViewModel.isPositive ? .theme.green : .theme.red
    }
    
    var body: some View {
        VStack {
            chartView
                .background(chartBackground)
                .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
            
            chartXAxis
                .padding(.horizontal, 4)
        }
        .frame(height: 200)
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2)) {
                    percentage = 1
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

private extension ChartView {
    var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in viewModel.data.indices {
                    let xPosition = geometry.size.width / CGFloat(viewModel.data.count) * CGFloat(index + 1)
                    
                    let yAxis = viewModel.maxY - viewModel.minY
                    let yPosition = (1 - CGFloat((viewModel.data[index] - viewModel.minY) / yAxis)) * geometry.size.height
                    
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
            .shadow(color: lineColor.opacity(0.25), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }
    
    var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    var chartYAxis: some View {
        VStack {
            Text(viewModel.maxYLabel)
            Spacer()
            Text(viewModel.midYLabel)
            Spacer()
            Text(viewModel.minYLabel)
        }
    }
    
    var chartXAxis: some View {
        HStack {
            Text(viewModel.minXLabel)
            Spacer()
            Text(viewModel.maxXLabel)
        }
    }
}
