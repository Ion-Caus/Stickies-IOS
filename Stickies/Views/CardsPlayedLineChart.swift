//
//  CardsPlayedGraph.swift
//  Stickies
//
//  Created by Ion Caus on 17.03.2023.
//

import SwiftUI

struct CardsPlayedLineChart: View {
    
    @FetchRequest
    private var entries: FetchedResults<CardEntry>
    
    @State
    private var data: [LineChartData] = []
    
    @State
    private var selectedElement: BarChart.DataSet.DataElement?
    
    private let paddingTrailing: CGFloat = 40
    
    @State
    private var updatedAt: Date = Date.now
    let daysBack: Int
    
    init(daysBack: Int) {
        self.daysBack = (daysBack > 1) ? daysBack : 1
        
        let interval = DateInterval.tomorrowTo(daysBack: daysBack)
        
        _entries = FetchRequest(fetchRequest: CardEntry.fetch(from: interval.start, to: interval.end), animation: .easeInOut)
    }
    
    var body: some View {
        let chartParameters = LineChartParameters(
            data: data,
            labelColor: .primary,
            secondaryLabelColor: .secondary,
            labelsAlignment: .left,
            dataPrecisionLength: 0,
            dataPrefix: "",
            dataSuffix: " cards played",
            indicatorPointColor: .red,
            indicatorPointSize: 10,
            lineColor: .blue,
            lineSecondColor: .purple,
            lineWidth: 3,
            dotsWidth: 4,
            displayMode: .default,
            dragGesture: false,
            hapticFeedback: true
        )
        
        return VStack {
            ZStack {
                let max = data.max { $0.value < $1.value }
             
                if let maxValue = max?.value {
                    createCoordinatePlane(maxValue: maxValue, minValue: 0.0)
                }
                
                LineChartView(lineChartParameters: chartParameters)
                    .padding(.top)
                    .padding(.trailing, paddingTrailing)
                  
            }
            .frame(height: 250)
        }
        .onAppear {
            Task {
                let interval = DateInterval.tomorrowTo(daysBack: daysBack)
                
                if !updatedAt.hasSame(.day, as: Date.now) {
                    let interval = DateInterval.tomorrowTo(daysBack: daysBack)
                    entries.nsPredicate = CardEntry.periodPredicate(from: interval.start, to: interval.end)
                    updatedAt = Date.now
                }
                
                self.data = createData(dates: interval.enumerateDates())
            }
        }
    }
    
    @ViewBuilder
    func createCoordinatePlane(maxValue: Double, minValue: Double) -> some View {
        VStack {
            ZStack {
                Divider()
                    .padding(.trailing, paddingTrailing)
                Text("\(maxValue, specifier: "%.0f")")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Spacer()
            
            ZStack {
                Divider()
                    .padding(.trailing, paddingTrailing)
                Text("\((maxValue - minValue) / 2, specifier: "%.0f")")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Spacer()
            
            ZStack {
                Divider()
                    .padding(.trailing, paddingTrailing)
                Text("\(minValue, specifier: "%.0f")")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.bottom, 10)
        .padding(.top, 5)
    }
    
    func createData(dates: [Date]) -> [LineChartData] {
        let grouped = Dictionary(
            grouping: entries.map { $0 },
            by: { $0.createdDate?.onlyDate }
        )

        return dates.compactMap { key in
            LineChartData(
                Double(grouped[key]?.count ?? 0),
                timestamp: key,
                label: key.formatted(.dateTime.day().month(.wide))
            )
        }
    }
    
}

struct CardsPlayedGraph_Previews: PreviewProvider {
    static var previews: some View {
        CardsPlayedLineChart(daysBack: 7)
    }
}
