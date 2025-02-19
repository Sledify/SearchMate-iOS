//
//  CreateReviewViewModel.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/15/25.
//

import FirebaseFirestore
import SwiftUI

class CreateReviewViewModel: ObservableObject {
    @Published var job: String = ""
    @Published var company: String = ""
    @Published var jobType: String = ""
    @Published var reviewContent: String = ""
    @Published var questions: [Questions] = []
    @Published var errorMessage: String = ""
    @Published var isSubmitted: Bool = false

    private let db = Firestore.firestore()

    func createReview() {
        guard !job.isEmpty, !company.isEmpty, !jobType.isEmpty, !reviewContent.isEmpty else {
            errorMessage = "모든 필드를 입력해주세요."
            return
        }

        let reviewId = UUID().uuidString
        let newReview: [String: Any] = [
            "id": reviewId,
            "job": job,
            "company": company,
            "jobType": jobType,
            "reviewContent": reviewContent,
            "questions": questions.map { ["question": $0.question, "answer": $0.answer] },
            "createdAt": Timestamp(date: Date())
        ]

        db.collection("reviews").document(reviewId).setData(newReview) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "저장 실패: \(error.localizedDescription)"
                } else {
                    self.isSubmitted = true
                    self.clearForm()
                }
            }
        }
    }

    func addQuestion() {
        questions.append(Questions(question: "", answer: ""))
    }

    func removeQuestion(at index: Int) {
        questions.remove(at: index)
    }

    private func clearForm() {
        job = ""
        company = ""
        jobType = ""
        reviewContent = ""
        questions = []
        errorMessage = ""
    }
}
