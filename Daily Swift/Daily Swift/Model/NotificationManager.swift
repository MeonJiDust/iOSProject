import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func addAlarm(id: [String], label: String, startDay: Date, endDay: Date, hour: Int, minute: Int) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Daily Routine"
        notificationContent.body = label
        
        for i in 0...endDay-startDay {
            var component = Calendar.current.dateComponents([.year,.month,.day], from: startDay.adding(days: i)!)
            component.hour = hour
            component.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
            let request = UNNotificationRequest(identifier: id[i], content: notificationContent, trigger: trigger)
            self.userNotificationCenter.add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func removeNotification(id: String) {
        self.userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
        print("noti id: \(id) 삭제 완료")
    }
}

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
    
    static func - (lhs: Date, rhs: Date) -> Int {
        return Int((lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate) / 86400)
    }
    
    func adding(days: Int) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.day = days

        return Calendar.current.date(byAdding: dateComponent, to: self)
    }
}

extension DateFormatter {
    static let shared = DateFormatter()
}
