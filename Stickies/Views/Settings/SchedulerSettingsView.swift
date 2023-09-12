//
//  SchedulerSettingsView.swift
//  Stickies
//
//  Created by Ion Caus on 01.08.2023.
//

import SwiftUI

struct SchedulerSettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode
    
    @AppStorage(AppStorageKeys.SpacedRepetitionEaseFactor) var easeFactor: Double = Constants.DefaultEaseFactor
    @AppStorage(AppStorageKeys.SpacedRepetitionEasyBonus) var easyBonus: Double = Constants.DefaultEasyBonus
    //@AppStorage(AppStorageKeys.SpacedRepetitionLearningSteps) var learningSteps: [Int] = Constants.DefaultLearningSteps
    
    var backgroundColor: Color {
        colorScheme == .dark ? .darkGray : .accentWhite
    }
    
    var strokeColor: Color {
        colorScheme == .dark ? .accentWhite : .darkGray
    }
    
    var body: some View {
        VStack(spacing: 20) {
            header
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Learning steps")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal)
                    
                    let learningSteps = Constants.DefaultLearningSteps
                        .map { TimeInterval($0 * 60).formatted() }
                        .joined(separator: ", ")
                    HStack {
                        Text("\(learningSteps)")
                            .font(.headline)
                        
                        Spacer()
                    }
                    .modifier(CapsuleBackground(textColor: strokeColor,
                                                backgroundColor: backgroundColor,
                                                strokeColor: strokeColor))
                    
                    Text("Due intervals for when the card is in the learning phase")
                        .font(.caption2)
                        .bold()
                        .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Ease factor")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal)
                    
                    HStack {
                        Text("\(easeFactor * 100, specifier: "%.0f")%")
                            .font(.headline)
                        
                        Spacer()
                        
                        Stepper("Easy factor", value: $easeFactor, in: 1.0...4.0, step: 0.5)
                            .labelsHidden()
                    }
                    .modifier(CapsuleBackground(textColor: strokeColor,
                                                backgroundColor: backgroundColor,
                                                strokeColor: strokeColor))
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Easy bonus")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal)
                    
                    HStack {
                        Text("\(easyBonus * 100, specifier: "%.0f")%")
                            .font(.headline)
                        
                        Spacer()
                        
                        Stepper("Easy bonus", value: $easyBonus, in: 1.0...4.0, step: 0.5)
                            .labelsHidden()
                    }
                    .modifier(CapsuleBackground(textColor: strokeColor,
                                                backgroundColor: backgroundColor,
                                                strokeColor: strokeColor))
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
    }
    
    var header: some View {
        ZStack(alignment: .center) {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.darkGray)
                        .clipShape(Circle())
                }
                Spacer()
            }
            
            Text("Scheduler")
                .font(.title)
                .bold()
        }
    }
}

struct SchedulerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulerSettingsView()
    }
}
