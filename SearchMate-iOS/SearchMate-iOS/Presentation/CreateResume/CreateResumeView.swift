//
//  CreateResumeView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import SwiftUI

struct CreateResumeView: View {
    @StateObject private var viewModel = CreateResumeViewModel()
    @State private var showAlert = false // ✅ 저장 완료 메시지 상태 추가

    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 50) {
                    VStack(spacing: 20) {
                        SearchMateTextField(placeholder: "이름", text: $viewModel.name)
                        SearchMateTextField(placeholder: "보유 기술 (쉼표로 구분)", text: $viewModel.skills)
                        SearchMateTextField(placeholder: "경력 사항", text: $viewModel.workExperience)
                        SearchMateTextField(placeholder: "학력 사항", text: $viewModel.education)
                        SearchMateTextField(placeholder: "자격증", text: $viewModel.certifications)
                        SearchMateTextField(placeholder: "프로젝트 경험", text: $viewModel.projects)

                        VStack(alignment: .leading, spacing: 20) {
                            Text("프리 토픽 (최대 6000자)")
                                .font(.headline)
                                .foregroundColor(.black)

                            ZStack(alignment: .topLeading) {
                                if viewModel.freeTopic.isEmpty {
                                    Text("내용을 입력하세요...")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 14)
                                        .padding(.top, 10)
                                }

                                TextEditor(text: $viewModel.freeTopic)
                                    .padding(12)
                                    .frame(height: 200)
                                    .font(.caption)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                        }
                    }

                    // ✅ "이력서 저장" 버튼 클릭 시 Alert 표시
                    Button(action: {
                        viewModel.createOrUpdateResume()
                        showAlert = true // ✅ 저장 완료 알림 활성화
                    }) {
                        Text("이력서 저장")
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(.smBlue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .alert("저장되었습니다!", isPresented: $showAlert) { // ✅ Alert 추가
                        Button("확인", role: .cancel) { }
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle("이력서 작성")
    }
}
