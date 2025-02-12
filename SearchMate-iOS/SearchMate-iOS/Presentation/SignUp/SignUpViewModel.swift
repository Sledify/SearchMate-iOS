//
//  SignUpViewModel.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import FirebaseFirestore
import FirebaseAuth

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

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isSignedUp = false
                }
                return
            }

            guard let user = authResult?.user else { return }

            // Firebase Authentication 프로필 업데이트
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = self.displayName
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Error updating display name: \(error.localizedDescription)")
                }

                // Firestore에 사용자 정보 저장 (commitChanges 완료 후 실행)
                self.saveUserToFirestore(user: user)
            }
        }
    }

    private func saveUserToFirestore(user: User) {
        let userRef = db.collection("users").document(user.uid)
        let createdAt = Timestamp(date: Date()) // Firestore에서 Timestamp 타입으로 저장

        let userData: [String: Any] = [
            "displayName": self.displayName,
            "email": self.email,
            "createdAt": createdAt
        ]

        userRef.setData(userData) { error in
            DispatchQueue.main.async {
                if let error = error {
                    AppStateManager.shared.logOut()
                    self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                    self.isSignedUp = false
                } else {
                    self.isSignedUp = true
                }
            }
        }
    }
}
