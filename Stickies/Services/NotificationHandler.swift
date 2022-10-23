//
//  NotificationHandler.swift
//  Stickies
//
//  Created by Ion Caus on 23.10.2022.
//

import Foundation
import UserNotifications

class NotificationHandler {
    
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if (success) {
                print("Access to notifications granted.")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    //Create Date from picker selected value.
    func createDate(weekday: Int, hour: Int, minute: Int, year: Int) -> Date{

        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.year = year
        components.weekday = weekday // Sunday = 1 ... Saturday = 7
        components.weekdayOrdinal = 10
        components.timeZone = .current

        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components)!
    }

    //Schedule Notification with weekly bases.
    func scheduleNotification(at date: Date, title: String, body: String) {

        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,], from: date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "Stickies"

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func getNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
    }
}
