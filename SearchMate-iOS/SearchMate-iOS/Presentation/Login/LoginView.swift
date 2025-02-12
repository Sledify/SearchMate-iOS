//
//  LoginView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import SwiftUI

struct LoginView: View {
    
    @State private var showSignUpView = false
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 50) {
            Image(.logo)
                .frame(width: 326, height: 114)
            
            VStack(spacing: 20) {
                SearchMateTextField(placeholder: "이메일", text: $viewModel.email)
           
                SearchMateTextField(placeholder: "비밀번호", text: $viewModel.password, isSecure: true)
                
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            
            VStack(spacing: 20) {
                Button(action: {
                    viewModel.login()
                }) {
                    Text("로그인")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: LoginView(), isActive: $showSignUpView) {
                    Button(action: {
                        showSignUpView = true
                    }) {
                        Text("회원가입")
                            .foregroundColor(.black)
                            .padding(.top, 10)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}
