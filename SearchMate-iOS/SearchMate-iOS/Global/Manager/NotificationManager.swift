//
//  NotificationManager.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/18/25.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {} // 싱글톤 패턴

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("알림 권한 요청 오류: \(error.localizedDescription)")
            }
            print("알림 권한 승인 여부: \(granted)")
        }
    }

    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "썰매"
        content.body = "썰매가 HUFS님께 딱 맞는 공고를 가져왔어요!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 스케줄링 오류: \(error.localizedDescription)")
            } else {
                print("1분 후 푸시 알림이 예약되었습니다.")
            }
        }
    }
}
