//
//  AppDelegate.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import SwiftUI
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // 🔔 알림 권한 요청 (앱 실행 시 자동 요청)
        NotificationManager.shared.requestPermission()

        // 🔔 UNUserNotificationCenter 델리게이트 설정 (포그라운드 알림 표시)
        UNUserNotificationCenter.current().delegate = self

        return true
    }
    
    // ✅ 앱이 실행 중일 때도 알림을 표시할 수 있도록 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge]) // 포그라운드에서도 알림 표시
    }
}

