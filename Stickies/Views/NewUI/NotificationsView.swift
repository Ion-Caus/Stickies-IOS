//
//  NotificationsView.swift
//  Stickies
//
//  Created by Ion Caus on 05.09.2023.
//

import SwiftUI
import WrappingStack

struct WeekDayButton: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var weekDay: WeekDay
    
    var backgroundColor: Color {
        colorScheme == .dark ? .darkGray : .accentWhite
    }
    
    var strokeColor: Color {
        colorScheme == .dark ? .accentWhite : .darkGray
    }

    var body: some View {
        CapsuleButton(
            text: weekDay.name,
            textColor: weekDay.isOn ? .white : strokeColor,
            backgroundColor: weekDay.isOn ? .accentBlue : backgroundColor,
            strokeColor: weekDay.isOn ? .accentBlueDark : strokeColor,
            width: 50)
        {
            weekDay.isOn.toggle()
        }
    }
}

struct NotificationsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var weekDays = [
        WeekDay(name: "M",  id: 2),
        WeekDay(name: "T", id: 3),
        WeekDay(name: "W",  id: 4),
        WeekDay(name: "T", id: 5),
        WeekDay(name: "F",  id: 6),
        WeekDay(name: "S", id: 7 ),
        WeekDay(name: "S", id: 1)]
    
    @StateObject private var notifier = NotificationHandler()
    @State private var selectedDate = Date()
    
    private let notificationTitle = "⚠️It's learning time.⚠️"
    private let notificationBody = "Improve your mind now."
    
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
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Select weekdays")
                    .font(.caption)
                    .bold()
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 3) {
                        ForEach($weekDays, id: \.id) { day in
                            WeekDayButton(weekDay: day)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Select time")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal)
                
                    CapsuleDatePicker(date: $selectedDate)
                }
                
                Spacer()
                
                CapsuleButton(
                    text: "Schedule",
                    textColor: .white,
                    backgroundColor: .accentBlue,
                    strokeColor: .accentBlueDark)
                {
                    scheduleNotifications()
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                WrappingHStack(id: \.identifier, alignment: .center) {
                    ForEach(notifier.notifications, id: \.identifier) { notificationRequest in
                        let trigger = notificationRequest.trigger as! UNCalendarNotificationTrigger
                        
                        HStack {
                            if let date = trigger.nextTriggerDate() {
                                CapsuleButton(
                                    text: formatDate(date, to: "HH:mm E"),
                                    textColor: .accentBlue,
                                    backgroundColor: .white,
                                    strokeColor: .darkGray)
                               
                            }
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                notifier.removeNotifications(withIdentifiers: notificationRequest.identifier)
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                    }
                }
            }
            .onAppear() {
                notifier.askPermission()
                notifier.fetchNotifications()
            }
            
            Spacer()
            
            CapsuleButton(text: "Remove all", textColor: .white, backgroundColor: .accentRed, strokeColor: .accentRedDark) {
                notifier.removeAllNotifications()
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
            
            Text("Search")
                .font(.title)
                .bold()
        }
    }
    
    func scheduleNotifications() {
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
