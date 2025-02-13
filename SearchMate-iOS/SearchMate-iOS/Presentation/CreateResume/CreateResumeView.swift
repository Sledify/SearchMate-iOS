//
//  CreateResumeView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import SwiftUI

struct CreateResumeView: View {
    @StateObject private var viewModel = CreateResumeViewModel()
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 50) {
                    Text("이력서 작성")
                        .font(.title)
                        .foregroundColor(.black)
                        .bold()

                    VStack(spacing: 20) {
                        SearchMateTextField(placeholder: "이름", text: $viewModel.name)
                        SearchMateTextField(placeholder: "보유 기술 (쉼표로 구분)", text: $viewModel.skills)
                        SearchMateTextField(placeholder: "경력 사항", text: $viewModel.workExperience)
                        SearchMateTextField(placeholder: "학력 사항", text: $viewModel.education)
                        SearchMateTextField(placeholder: "자격증", text: $viewModel.certifications)
                        SearchMateTextField(placeholder: "프로젝트 경험", text: $viewModel.projects)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("프리 토픽 (최대 6000자)")
                                .font(.headline)

                            TextEditor(text: $viewModel.freeTopic)
                                .frame(height: 200)
                                .border(Color.gray, width: 1)
                                .padding(.horizontal)
                        }
                    }

                    Button(action: {
                        viewModel.createOrUpdateResume()
                    }) {
                        Text("이력서 저장")
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(false)
    }
}
