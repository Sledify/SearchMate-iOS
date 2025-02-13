//
//  TestViewModel.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/13/25.
//

import SwiftUI

class TestViewModel: ObservableObject {
    @Published var recommendedMeal: String = "추천 메뉴가 여기에 표시됩니다."
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private let gptService = TestGPTService()

    func fetchMealRecommendation() {
        isLoading = true
        errorMessage = ""

        Task {
            do {
                let meal = try await gptService.requestGPTResponse()
                DispatchQueue.main.async {
                    self.recommendedMeal = meal
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "추천 실패: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}
