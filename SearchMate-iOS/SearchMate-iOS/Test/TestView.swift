//
//  TestView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/13/25.
//

import SwiftUI

struct TestView: View {
    @StateObject private var viewModel = TestViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("🍽 식사 추천")
                .font(.largeTitle)
                .bold()

            Text(viewModel.recommendedMeal)
                .font(.title2)
                .foregroundColor(.smBlue)
                .padding()
                .multilineTextAlignment(.center)

            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
            }

            Button(action: {
                viewModel.fetchMealRecommendation()
            }) {
                Text("식사 추천 받기")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.smBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
