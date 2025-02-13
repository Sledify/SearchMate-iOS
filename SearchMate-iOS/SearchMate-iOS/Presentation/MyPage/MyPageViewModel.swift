//
//  MyPageViewModel.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/13/25.
//

import FirebaseFirestore
import SwiftUI

class MyPageViewModel: ObservableObject {
    @Published var displayName: String = "로딩 중..."
    @Published var email: String = "로딩 중..."
    @Published var resume: Resume?

    private let db = Firestore.firestore()

    func fetchUserData() {
        guard let userId = AuthManager.shared.getCurrentUserId() else {
            print("🚨 로그인된 사용자 없음")
            return
        }

        print("🔍 Firestore에서 사용자 정보 검색 중... userId: \(userId)")

        // ✅ Firestore에서 유저 정보 가져오기
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("🚨 사용자 정보 가져오기 실패: \(error.localizedDescription)")
                return
            }

            guard let data = document?.data() else {
                print("🚨 사용자 정보가 Firestore에 없음")
                return
            }

            DispatchQueue.main.async {
                self.displayName = data["displayName"] as? String ?? "이름 없음"
                self.email = data["email"] as? String ?? "이메일 없음"
            }

            print("✅ 사용자 정보 로드 완료: \(self.displayName), \(self.email)")
        }

        // ✅ Firestore에서 해당 사용자의 이력서 가져오기
        db.collection("resume_posts")
            .whereField("userId", isEqualTo: userId)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("🚨 이력서 가져오기 실패: \(error.localizedDescription)")
                    return
                }

                guard let document = snapshot?.documents.first else {
                    print("🚨 Firestore에서 해당 사용자의 이력서를 찾을 수 없음")
                    return
                }

                do {
                    let fetchedResume = try document.data(as: Resume.self)
                    DispatchQueue.main.async {
                        self.resume = fetchedResume
                    }
                    print("✅ Firestore에서 이력서 로드 성공!")
                } catch {
                    print("🚨 Firestore 데이터 변환 실패: \(error.localizedDescription)")
                }
            }
    }
}
