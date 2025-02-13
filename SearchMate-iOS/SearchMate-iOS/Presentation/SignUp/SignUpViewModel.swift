//
//  SignUpViewModel.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var isSignedUp: Bool = false

    private let db = Firestore.firestore()

    func signUp() {
        guard password == confirmPassword else {
            DispatchQueue.main.async {
                self.errorMessage = "비밀번호가 일치하지 않습니다."
                self.isSignedUp = false
            }
            return
        }

        AuthManager.shared.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let user):
                    self.updateUserProfile(user: user)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isSignedUp = false
                }
            }
        }
    }

    /// ✅ Firebase Authentication의 `displayName` 업데이트 후 Firestore 저장
    private func updateUserProfile(user: User) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = self.displayName
        changeRequest.commitChanges { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "프로필 업데이트 실패: \(error.localizedDescription)"
                }
            }
            self?.saveUserToFirestore(user: user)
        }
    }

    /// ✅ Firestore에 사용자 정보 저장
    private func saveUserToFirestore(user: User) {
        let userRef = db.collection("users").document(user.uid)
        let createdAt = Timestamp(date: Date())

        let userData: [String: Any] = [
            "displayName": self.displayName,
            "email": self.email,
            "createdAt": createdAt
        ]

        userRef.setData(userData) { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if let error = error {
                    AuthManager.shared.signOut { _ in }
                    self.errorMessage = "유저 데이터 저장 실패: \(error.localizedDescription)"
                    self.isSignedUp = false
                } else {
                    self.isSignedUp = true
                }
            }
        }
    }
}
