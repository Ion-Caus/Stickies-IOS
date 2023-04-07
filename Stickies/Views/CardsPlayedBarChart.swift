//
//  CardsPlayedBarChart.swift
//  Stickies
//
//  Created by Ion Caus on 07.04.2023.
//

import SwiftUI

struct CardsPlayedBarChart : View {
    @Environment(\.scenePhase) var scenePhase
    
    @FetchRequest
    private var entries: FetchedResults<CardEntry>
    
    @State
    private var dataSet = BarChart.DataSet(elements: [], selectionColor: Color.red)
    
    @State
    private var selectedElement: BarChart.DataSet.DataElement?
    
    private var days = [Date]()
    private let paddingTrailing: CGFloat = 40
    
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
        VStack {
            ZStack {
                let max = dataSet.elements
                    .flatMap{ $0.bars }
                    .max { $0.value < $1.value }
             
                if let maxValue = max?.value {
                    createCoordinatePlane(maxValue: maxValue, minValue: 0.0)
                }
                
                let barWidth = daysBack > 7 ? 6.0 : 12.0
                BarChart(dataSet: dataSet, selectedElement: $selectedElement, barWidth: barWidth)
                    .padding(.top)
                    .padding(.trailing, paddingTrailing)
            }
            .frame(height: 250)
        }
        .onAppear {
            let grouped = Dictionary(
                grouping: entries.map { $0 },
                by: { $0.createdDate?.onlyDate }
            )
            
            let elements: [BarChart.DataSet.DataElement] = days.compactMap { key in
                
                let value = Double(grouped[key]?.count ?? 0)
                let color = value < 5 ? Color.gray : Color.red
                
                return BarChart.DataSet.DataElement(
                    date: key,
                    xLabel: key.formatted(.dateTime.weekday()),
                    bars: [
                        BarChart.DataSet.DataElement.Bar(value: value, color: color)
                    ])
            }
                    
            dataSet = BarChart.DataSet(elements: elements, selectionColor: Color.gray.opacity(0.7))
        }
        .onChange(of: scenePhase) { newPhase in
//            if newPhase == .active {
//                print("Active")
//            }
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
    
}
struct CardsPlayedBarChart_Previews: PreviewProvider {
    static var previews: some View {
        CardsPlayedBarChart(daysBack: 7)
    }
}
