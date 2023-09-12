//
//  AnalyticsSettingsView.swift
//  Stickies
//
//  Created by Ion Caus on 17.03.2023.
//

import SwiftUI

struct AnalyticsSettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.createdDate, order: .reverse)
    ])
    private var cardEntries: FetchedResults<CardEntry>
    
    var backgroundColor: Color {
        colorScheme == .dark ? .darkGray : .accentWhite
    }
    
    var strokeColor: Color {
        colorScheme == .dark ? .accentWhite : .darkGray
    }
    
    var body: some View {
        VStack {
            header
                .padding(.horizontal)
            
            List {
                ForEach(cardEntries, id: \.id) { entry in
                    VStack(spacing: 10) {
                        HStack {
                            Text(entry.card?.word ?? "[card]")
                                .foregroundColor(strokeColor)
                                .font(.headline)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text(entry.review ?? "[review]")
                                .foregroundColor(strokeColor)
                                .font(.subheadline)
                               
                            
                            Spacer()
                            
                            Text(entry.createdDate?.formatted(date: .abbreviated, time: .shortened) ?? "[datetime]")
                                .foregroundColor(Color.gray)
                                .font(.subheadline)
                              
                            
                        }
                    }
                    .padding(.vertical)
                    .contextMenu {
                        Button(role: .destructive) {
                            DataController.shared.context.delete(entry)
                            DataController.shared.save()

                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                }
                .listRowBackground(
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(strokeColor)
                            .offset(y: 3)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(strokeColor, lineWidth: 1)
                            .background(backgroundColor.cornerRadius(10))
                    }
                    .padding(5)
                )
                .listRowSeparator(.hidden)
            }
            .listStyle(InsetGroupedListStyle())
            .cornerRadius(CardConstants.cornerRadius)
            
            Spacer()
            CapsuleButton(text: "Remove all", textColor: .white, backgroundColor: .accentRed, strokeColor: .accentRedDark) {
                DataController.shared.delete(fetchRequest: CardEntry.fetchRequest())
            }
        }
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
            
            Text("Analytics")
                .font(.title)
                .bold()
        }
    }
}

struct AnalyticsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsSettingsView()
    }
}
