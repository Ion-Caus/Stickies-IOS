//
//  NotificationsView.swift
//  Stickies
//
//  Created by Ion Caus on 23.10.2022.
//

import SwiftUI

struct NotificationsView: View {
    
    let weekDays = ["Su", "M", "Tu", "W", "Th", "F", "St"]
    @State private var selectedDate = Date()

    let notifier = NotificationHandler()
    
    let notificationTitle = "⚠️It's learning time.⚠️"
    let notificationBody = "Improve your mind now."
    
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .center, spacing: 10) {
                ForEach(weekDays, id: \.self) { weekDay in
                    Toggle(weekDay, isOn: .constant(true))
                        .toggleStyle(ButtonToggleStyle())
                }
            }
            
            DatePicker("Pick a time:", selection: $selectedDate, displayedComponents: .hourAndMinute)
            
            Button {
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: selectedDate)
                let minute = calendar.component(.minute, from: selectedDate)
                let year = calendar.component(.year, from: selectedDate)
                
                for weekDay in 1...7 {
                    let date = notifier.createDate(weekday: weekDay, hour: hour, minute: minute, year: year)
                    
                    notifier.scheduleNotification(
                       at: date,
                       title: notificationTitle,
                       body: notificationBody)
                }
                
    
            } label: {
                Text("Schedule notifications")
            }
            
            Spacer()
            Text("Debug")
            HStack(spacing: 20) {
                Button("Remove all") {
                    notifier.removeAllNotifications()
                }
                
                Button("Print pending") {
                    notifier.getNotifications()
                }
            }
            
                
            
                
            Spacer()
            
            Text("Not working?")
               .foregroundColor(.gray)
               .italic()
            
            Button("Request permissions") {
                notifier.askPermission()
            }
            
        }
        .padding()
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
