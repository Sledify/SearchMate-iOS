//
//  LoginViewModel.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import SwiftUI
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isLoggedIn = false
                } else {
                    self?.errorMessage = ""
                    self?.isLoggedIn = true
                }
            }
        }
    }
}
