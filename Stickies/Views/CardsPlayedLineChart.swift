//
//  CardsPlayedGraph.swift
//  Stickies
//
//  Created by Ion Caus on 17.03.2023.
//

import SwiftUI

struct CardsPlayedGraph: View {
    
    @FetchRequest
    private var entries: FetchedResults<CardEntry>
    
    @State
    private var data = [LineChartData]()
    
    private var days = [Date]()
    
    @Environment(\.scenePhase) var scenePhase
    
    let daysBack: Int
    
    init(daysBack: Int) {
        self.daysBack = (daysBack > 1) ? daysBack : 1
        
        let cal = Calendar.current
        let midnight = cal.startOfDay(for: Date())
        
        let tomorrow = cal.date(byAdding: .day, value: 1, to: midnight)!
    
        var date = midnight
        
        for _ in 1 ... daysBack {
            days.insert(date, at: 0)
            date = cal.date(byAdding: .day, value: -1, to: date)!
        }
        
        let from = days.first!
        let end = tomorrow
        
        
        _entries = FetchRequest(fetchRequest: CardEntry.fetch(from: from, to: end), animation: .easeInOut)
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
                    VStack {
                        ZStack {
                            Divider()
                                .padding(.trailing, 50)
                            Text(String(maxValue))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Divider()
                                .padding(.trailing, 50)
                            Text(String(maxValue / 2))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Divider()
                                .padding(.trailing, 50)
                            Text("0")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(.bottom, 5)
                    .padding(.top)
                }
                
                LineChartView(lineChartParameters: chartParameters)
                    .padding(.trailing, 40)
                
            }
            .frame(height: 250)
        }
        .onAppear {
            let grouped = Dictionary(
                grouping: entries.map { $0 },
                by: { $0.createdDate?.onlyDate }
            )

            self.data = days.compactMap { key in
                
                LineChartData(
                    Double(grouped[key]?.count ?? 0),
                    timestamp: key,
                    label: key.formatted(.dateTime.day().month(.wide))
                )
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
                
//                guard days.last == Date.now else {
//
//                }
           }
        }
    }
    
}

struct CardsPlayedGraph_Previews: PreviewProvider {
    static var previews: some View {
        CardsPlayedGraph(daysBack: 7)
    }
}
