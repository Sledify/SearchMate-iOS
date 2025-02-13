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
            VStack(alignment: .leading, spacing: 15) {
                Text(post.job)
                    .font(.largeTitle)
                    .bold()

                Text(post.company)
                    .font(.title2)
                    .foregroundColor(.secondary)

                Text("고용 형태: \(post.jobType)")
                    .font(.subheadline)

                Text("마감일: \(post.deadline)")
                    .font(.subheadline)
                    .foregroundColor(.red)

                Divider()

                Text("자격 요건")
                    .font(.headline)
                Text(post.qualifications)

                Text("우대 사항")
                    .font(.headline)
                Text(post.preferredQualifications)

                Divider()

                Text("채용 공고 상세")
                    .font(.headline)
                Text(post.jobDescription)

                Divider()

                // ✅ 자기소개서 문항 리스트 추가
                if !post.questions.isEmpty {
                    Text("자기소개서 문항")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(post.questions, id: \.self) { question in
                            Text("• \(question)")
                                .padding(.vertical, 2)
                        }
                    }
                }

                // ✅ "AI 작성 보기" 버튼 추가
                NavigationLink(destination: AIView(post: post)) {
                    Text("AI 작성 보기")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.vertical, 10)
                }

                Link("지원하러 가기", destination: URL(string: post.URL)!)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
            }
            .padding()
        }
        .navigationTitle("채용 정보")
    }
}
