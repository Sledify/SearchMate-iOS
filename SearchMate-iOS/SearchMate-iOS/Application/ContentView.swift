//
//  ContentView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthManager.shared  // ✅ 로그인 상태 관찰

    var body: some View {
        NavigationStack {
            if authManager.isLoggedIn {
                MainView()  // ✅ 로그인 상태이면 MainView로 이동
            } else {
                LoginView()  // ✅ 로그아웃 상태이면 LoginView로 이동
            }
        }
        .onAppear {
            print("🔍 현재 로그인 상태: \(authManager.isLoggedIn ? "로그인됨" : "로그아웃됨")")
        }
    }
}

#Preview {
    ContentView()
}
