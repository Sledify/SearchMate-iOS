//
//  MyPageView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/13/25.
//

import SwiftUI

struct MyPageView: View {
    @StateObject private var viewModel = MyPageViewModel()
    @State private var navigateToCreateResume = false  // ✅ 네비게이션 상태 추가

    var body: some View {
        NavigationStack {  // ✅ MyPageView에서 직접 NavigationStack 관리
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
                    } else {
                        Text("이력서 정보가 없습니다.")
                            .foregroundColor(.gray)
                    }
                }
                .padding()

                Spacer()

                // ✅ "이력서 작성" 버튼
                Button(action: {
                    navigateToCreateResume = true  // ✅ 버튼 클릭 시 상태 변경
                }) {
                    Text("이력서 작성")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .navigationDestination(isPresented: $navigateToCreateResume) {
                    CreateResumeView()
                } // ✅ 네비게이션이 작동하도록 설정
            }
            .padding()
            .onAppear {
                viewModel.fetchUserData()
            }
        }
    }
}
