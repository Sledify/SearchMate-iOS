//
//  SignUpView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("회원가입")
                    .font(.title)
                    .foregroundColor(.black)
                    .bold()
                
                VStack(spacing: 20) {
                    SearchMateTextField(placeholder: "닉네임", text: $viewModel.displayName)
                    
                    SearchMateTextField(placeholder: "이메일", text: $viewModel.email)
                    
                    SearchMateTextField(placeholder: "비밀번호", text: $viewModel.password, isSecure: true)
                    
                    SearchMateTextField(placeholder: "비밀번호 확인", text: $viewModel.confirmPassword, isSecure: true)
                }
                
                Button(action: {
                    viewModel.signUp()
                }) {
                    Text("가입하기")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .tint(.black)
            .accentColor(.black)
            .foregroundColor(.black)
        }
        .fullScreenCover(isPresented: $viewModel.isSignedUp) {
            MainView()
        }
    }
}
