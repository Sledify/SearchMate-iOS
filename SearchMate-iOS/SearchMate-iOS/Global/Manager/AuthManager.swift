//
//  AuthManager.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import FirebaseAuth
import Combine

class AuthManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false  // ✅ 로그인 상태 관리
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    static let shared = AuthManager()

    private init() {
        setupAuthListener()
    }

    /// ✅ Firebase Auth 상태 변경 감지
    private func setupAuthListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isLoggedIn = (user != nil)
            }
        }
    }

    /// ✅ 현재 로그인된 유저의 UID 가져오기
    func getCurrentUserId() -> String? {
        return currentUser?.uid
    }

    /// ✅ 현재 로그인된 유저의 이메일 가져오기
    func getCurrentUserEmail() -> String? {
        return currentUser?.email
    }

    /// ✅ 회원가입 (이메일 & 비밀번호)
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let user = result?.user {
                    self?.currentUser = user
                    self?.isLoggedIn = true
                    completion(.success(user))
                }
            }
        }
    }

    /// ✅ 로그인 (이메일 & 비밀번호)
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let user = result?.user {
                    self?.currentUser = user
                    self?.isLoggedIn = true
                    completion(.success(user))
                }
            }
        }
    }

    /// ✅ 로그아웃
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.currentUser = nil
                self.isLoggedIn = false
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
