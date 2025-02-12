//
//  LoginViewModel.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false

    func login() {

    }
}
