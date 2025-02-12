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
