//
//  MyPageView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/13/25.
//

import SwiftUI

struct MyPageView: View {
    @StateObject private var viewModel = MyPageViewModel()
    @State private var navigateToCreateResume = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("마이페이지")
                        .font(.largeTitle)
                        .bold()

                    Divider()

                    // ✅ 유저 정보 표시
                    VStack(alignment: .leading, spacing: 10) {
                        Text("이름: \(viewModel.displayName)")
                            .font(.headline)
                        Text("이메일: \(viewModel.email)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()

                    Divider()

                    // ✅ 사용자 이력서 표시
                    VStack(alignment: .leading, spacing: 10) {
                        Text("📄 작성한 이력서")
                            .font(.headline)

                        if let resume = viewModel.resume {
                            Text("📌 기술: \(resume.skills.joined(separator: ", "))")
                            Text("💼 경력: \(resume.workExperience)")
                            Text("🎓 학력: \(resume.education)")
                            Text("🏅 자격증: \(resume.certifications)")
                            Text("📝 프로젝트: \(resume.projects)")

                            Divider()

                            // ✅ Free Topic 추가
                            VStack(alignment: .leading, spacing: 10) {
                                Text("📝 프리 토픽")
                                    .font(.headline)

                                Text(resume.freeTopic.isEmpty ? "내용이 없습니다." : resume.freeTopic)
                                    .font(.body)
                                    .foregroundColor(resume.freeTopic.isEmpty ? .gray : .black)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                            }
                        } else {
                            Text("이력서 정보가 없습니다.")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()

                    Spacer()

                    // ✅ "이력서 작성" 버튼
                    Button(action: {
                        navigateToCreateResume = true
                    }) {
                        Text("이력서 작성")
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(.smBlue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .navigationDestination(isPresented: $navigateToCreateResume) {
                        CreateResumeView()
                    }

                    // ✅ 로그아웃 버튼
                    Button(action: {
                        viewModel.logout()
                    }) {
                        Text("로그아웃")
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(.smGray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .padding()
            }
            .onAppear {
                viewModel.fetchUserData()
            }
        }
    }
}
