//
//  ReviewDetailView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/15/25.
//

import SwiftUI

struct ReviewDetailView: View {
    let review: Review

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text(review.job)
                    .font(.title)
                    .bold()

                Text(review.company)
                    .font(.title3)
                    .foregroundColor(.secondary)

                Text("고용 형태: \(review.jobType)")
                    .font(.subheadline)

                Divider()

                Text("합격 리뷰")
                    .font(.headline)
                Text(review.reviewContent)
                    .font(.body)
                    .padding()

                Divider()

                // ✅ 자기소개서 문항과 답변
                if !review.questions.isEmpty {
                    Text("자기소개서 문항")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(review.questions.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 5) {
                                Text("질문 \(index + 1): \(review.questions[index].question)")
                                    .font(.subheadline)
                                    .bold()
                                
                                Text(review.questions[index].answer)
                                    .font(.caption)
                                    .padding(15)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("리뷰 상세")
    }
}
