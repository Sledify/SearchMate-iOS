//
//  ReviewView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/15/25.
//

import SwiftUI

struct ReviewView: View {
    @StateObject private var viewModel = ReviewViewModel()

    var body: some View {
        List(viewModel.reviews) { review in
            Text("HUFS님을 위한 합격 리뷰를 썰매가 모아 봤어요!")
                .font(.subheadline)
            NavigationLink(destination: CreditReviewView(review: review)) { // ✅ CreditReviewView로 이동
                VStack(alignment: .leading) {
                    Text(review.job)
                        .font(.headline)
                    Text(review.company)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(review.reviewContent)
                        .lineLimit(2)
                        .font(.body)
                }
            }
        }
        .navigationTitle("합격 리뷰")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                NavigationLink(destination: CreateReviewView()) {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
        }
        .onAppear {
            viewModel.fetchReviews()
        }
    }
}
