//
//  CardsPlayedBarChart.swift
//  Stickies
//
//  Created by Ion Caus on 07.04.2023.
//

import SwiftUI

struct CardsPlayedBarChart : View {
    @FetchRequest
    private var entries: FetchedResults<CardEntry>
    
    @State
    private var elements: [BarChart.DataSet.DataElement] = []
    
//    @State
//    private var selectedElement: BarChart.DataSet.DataElement?
    
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
        let dataSet = BarChart.DataSet(elements: elements, selectionColor: Color.gray.opacity(0.7))

        return VStack {
            ZStack {
                let max = dataSet.elements
                    .flatMap{ $0.bars }
                    .max { $0.value < $1.value }
             
                if let maxValue = max?.value {
                    createCoordinatePlane(maxValue: maxValue, minValue: 0.0)
                }
                
                let barWidth = daysBack > 7 ? 6.0 : 12.0
                BarChart(dataSet: dataSet, selectedElement: .constant(nil), barWidth: barWidth)
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
                
                self.elements = createDataElements(dates: interval.enumerateDates())
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
    
    func createDataElements(dates: [Date]) -> [BarChart.DataSet.DataElement] {
        let grouped = Dictionary(
            grouping: entries.map { $0 },
            by: { $0.createdDate?.onlyDate }
        )
        
        return dates.compactMap { key in
            let value = Double(grouped[key]?.count ?? 0)
            let color = value < 5 ? Color.gray : Color.red
            
            return BarChart.DataSet.DataElement(
                date: key,
                xLabel: key.formatted(.dateTime.weekday()),
                bars: [
                    BarChart.DataSet.DataElement.Bar(value: value, color: color)
                ])
        }
    }
}
struct CardsPlayedBarChart_Previews: PreviewProvider {
    static var previews: some View {
        CardsPlayedBarChart(daysBack: 7)
    }
}
