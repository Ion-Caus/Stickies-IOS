//
//  NotificationsView.swift
//  Stickies
//
//  Created by Ion Caus on 23.10.2022.
//

import SwiftUI

struct WeekDay: Identifiable {
    let name: String
    let id: Int
    var isOn: Bool = true
}

struct WeekDayToggle: View {
    @Binding var weekDay: WeekDay

    @State private var isOn = true

    var body: some View {
        ZStack {
            if weekDay.isOn {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.yellow.opacity(0.9))
            }
            
            Text(weekDay.name)
                .bold()
                
        }
        .onTapGesture {
            weekDay.isOn.toggle()
        }
        .frame(width: 40, height: 40, alignment: .center)
    }
}

struct NotificationsView: View {
    
    @State var weekDays = [
        WeekDay(name: "M",  id: 2),
        WeekDay(name: "T", id: 3),
        WeekDay(name: "W",  id: 4),
        WeekDay(name: "T", id: 5),
        WeekDay(name: "F",  id: 6),
        WeekDay(name: "S", id: 7 ),
        WeekDay(name: "S", id: 1)]
    
    @State private var selectedDate = Date()

    @StateObject var notifier = NotificationHandler()
    
    let notificationTitle = "⚠️It's learning time.⚠️"
    let notificationBody = "Improve your mind now."
    
    var body: some View {
        VStack {
            
            HStack(alignment: .center, spacing: 10) {
                ForEach($weekDays, id: \.id) { weekDay in
                    WeekDayToggle(weekDay: weekDay)
                }
            }
            .padding(.vertical)
            
            DatePicker("Pick a time:", selection: $selectedDate, displayedComponents: .hourAndMinute)
            
            Button {
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: selectedDate)
                let minute = calendar.component(.minute, from: selectedDate)
                let year = calendar.component(.year, from: selectedDate)
                
                for weekDay in weekDays {
                    guard weekDay.isOn else { continue }
                    
                    let date = notifier.createDate(weekday: weekDay.id, hour: hour, minute: minute, year: year)
                    
                    notifier.scheduleNotification(
                       at: date,
                       title: notificationTitle,
                       body: notificationBody)
                }
                
    
            } label: {
                Text("Schedule notifications")
            }
            .padding(.bottom)
            
            List {
                ForEach(notifier.notifications, id: \.identifier) { notificationRequest in
        
                    let trigger = notificationRequest.trigger as! UNCalendarNotificationTrigger
                    
                    HStack {
                        if let date = trigger.nextTriggerDate() {
                        
                            Text(formatDate(date, to: "HH:mm EEEE"))
                        }
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            notifier.removeNotifications(withIdentifiers: notificationRequest.identifier)
                            
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                }
            }
            .onAppear() {
                self.notifier.fetchNotifications()
            }
            
            Text("Not working?")
               .foregroundColor(.gray)
               .italic()
            
            Button("Request permissions") {
                notifier.askPermission()
            }
            
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Remove all notifications") {
                        notifier.removeAllNotifications()
                    }
                    
                } label: {
                     Image(systemName: "terminal")
                }
              }
        }
    }
    
    func formatDate(_ date: Date, to format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
        
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
