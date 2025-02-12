//
//  CreatePostView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import SwiftUI

struct CreatePostView: View {
    @StateObject private var viewModel = CreatePostViewModel()
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 50) {
                    Text("지원한 공고 등록")
                        .font(.title)
                        .foregroundColor(.black)
                        .bold()
                    
                    VStack(spacing: 20) {
                        SearchMateTextField(placeholder: "직무", text: $viewModel.job)
                        SearchMateTextField(placeholder: "회사명", text: $viewModel.company)
                        SearchMateTextField(placeholder: "고용 형태", text: $viewModel.jobType)
                        SearchMateTextField(placeholder: "자격 요건", text: $viewModel.qualifications)
                        SearchMateTextField(placeholder: "우대 사항", text: $viewModel.preferredQualifications)
                        SearchMateTextField(placeholder: "마감일 (YYYY.MM.DD)", text: $viewModel.deadline)
                        SearchMateTextField(placeholder: "채용 상세 설명", text: $viewModel.jobDescription)
                        SearchMateTextField(placeholder: "채용 URL", text: $viewModel.URL)
                    }
                    
                    Button(action: {
                        viewModel.createPost()
                    }) {
                        Text("등록하기")
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    if viewModel.isSubmitted {
                        Text("공고가 등록되었습니다!")
                            .foregroundColor(.green)
                    }
                    
                    Spacer().frame(height: 100) // 키보드 여백 추가
                }
                .padding()
            }
        }
    }
}
