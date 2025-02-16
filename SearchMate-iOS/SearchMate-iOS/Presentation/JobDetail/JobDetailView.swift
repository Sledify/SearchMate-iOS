//
//  JobDetailView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import SwiftUI

struct JobDetailView: View {
    let post: Post

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // ✅ 채용 제목과 회사명 정리
                VStack(alignment: .leading, spacing: 5) {
                    Text(post.job)
                        .font(.title2)
                        .bold()

                    Text(post.company)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 10)

                // ✅ 채용 정보 강조 (박스 스타일 적용)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "briefcase.fill")
                            .foregroundColor(.blue)
                        Text("고용 형태: \(post.jobType)")
                            .font(.subheadline)
                    }

                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.red)
                        Text("마감일: \(post.deadline)")
                            .font(.subheadline)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

                Divider()

                // ✅ 자격 요건 & 우대 사항 스타일 개선
                Group {
                    SectionHeader(title: "자격 요건")
                    Text(post.qualifications)
                        .font(.body)
                        .padding(.bottom, 10)

                    SectionHeader(title: "우대 사항")
                    Text(post.preferredQualifications)
                        .font(.body)
                }

                Divider()

                // ✅ 채용 공고 상세
                SectionHeader(title: "채용 공고 상세")
                Text(post.jobDescription)

                Divider()

                // ✅ 자기소개서 문항 리스트
                if !post.questions.isEmpty {
                    SectionHeader(title: "자기소개서 문항")

                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(post.questions, id: \.self) { question in
                            HStack(alignment: .top) {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 6))
                                    .foregroundColor(.gray)
                                    .padding(.top, 5)
                                Text(question)
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                    }
                }

                // ✅ "AI 작성 보기" 버튼
                NavigationLink(destination: AIView(post: post)) {
                    Text("AI 작성 보기")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(.smBlue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 10)
                }

                // ✅ 지원하러 가기 버튼 (더 강조)
                Button(action: {
                    if let url = URL(string: post.URL), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("지원하러 가기")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(.smGray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 5)
            }
            .padding()
        }
        .navigationTitle("채용 정보")
    }
}

// ✅ 공통으로 사용할 Section Header 컴포넌트
struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .bold()
            .padding(.top, 15)
    }
}
