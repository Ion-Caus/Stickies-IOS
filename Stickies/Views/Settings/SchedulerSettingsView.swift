//
//  SchedulerSettingsView.swift
//  Stickies
//
//  Created by Ion Caus on 01.08.2023.
//

import SwiftUI

struct SchedulerSettingsView: View {
    @AppStorage(AppStorageKeys.SpacedRepetitionEaseFactor) var easeFactor: Double = Constants.DefaultEaseFactor
    //@AppStorage(AppStorageKeys.SpacedRepetitionLearningSteps) var learningSteps: [Int] = Constants.DefaultLearningSteps
    
    var body: some View {
        Form {
            
            Section {
                Text(Constants.DefaultLearningSteps
                    .map{String(TimeInterval($0 * 60).formatted())}
                    .joined(separator: ", ")
                )
                
            } header: {
                Text("Learning steps")
            } footer: {
                Text("Due intervals for when the card in the learning phase")
            }
               
            Section(header: Text("Advance")) {
                HStack {
                    Text("Ease factor")
                    Spacer()
                    
                    Text("\(easeFactor * 100, specifier: "%.0f")%")
                    Stepper("Rate", value: $easeFactor, in: 1.0...4.0, step: 0.5)
                        .labelsHidden()
                }
            }
        }
        .navigationTitle("Scheduler")
    }
}

struct SchedulerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulerSettingsView()
    }
}
