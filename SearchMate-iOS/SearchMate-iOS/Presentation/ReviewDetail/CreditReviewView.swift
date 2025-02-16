//
//  CreditReviewView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/15/25.
//

import SwiftUI

struct CreditReviewView: View {
    let review: Review
    @State private var navigateToDetail = false

    var body: some View {
        VStack(spacing: 30) { // ✅ 간격 조정
            Spacer()

            // ✅ 🔒 자물쇠 아이콘 크게 표시
            Image(systemName: "lock.fill")
                .font(.system(size: 80)) // 아이콘 크기 크게
                .foregroundColor(.smGray)

            Text("열람권을 사용하여 리뷰를 보시겠습니까?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            Button(action: {
                navigateToDetail = true
            }) {
                Text("리뷰 보기")
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(.smBlue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .navigationDestination(isPresented: $navigateToDetail) {
                ReviewDetailView(review: review)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("리뷰 열람")
    }
}
