//
//  CreatePostViewModel.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

//
//  CreatePostViewModel.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import FirebaseFirestore
import SwiftUI

class CreatePostViewModel: ObservableObject {
    @Published var job: String = ""
    @Published var company: String = ""
    @Published var jobType: String = ""
    @Published var qualifications: String = ""
    @Published var preferredQualifications: String = ""
    @Published var deadline: String = ""
    @Published var jobDescription: String = ""
    @Published var questions: [String] = [] // 배열로 변경
    @Published var URL: String = ""
    @Published var errorMessage: String = ""
    @Published var isSubmitted: Bool = false

    private let db = Firestore.firestore()

    func createPost() {
        guard !job.isEmpty, !company.isEmpty, !jobType.isEmpty, !qualifications.isEmpty, !jobDescription.isEmpty, !URL.isEmpty else {
            errorMessage = "모든 필드를 입력해주세요."
            return
        }

        // 마감일을 Firestore에 저장할 Date 포맷으로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let deadlineDate = dateFormatter.date(from: deadline) ?? Date()

        let postId = UUID().uuidString
        let newPost: [String: Any] = [
            "id": postId,
            "job": job,
            "company": company,
            "jobType": jobType,
            "qualifications": qualifications,
            "preferredQualifications": preferredQualifications,
            "deadline": Timestamp(date: deadlineDate),
            "jobDescription": jobDescription,
            "URL": URL,
            "questions": questions, // Firestore에서 배열로 저장
            "isApplied": true,
            "createdAt": Timestamp(date: Date())
        ]

        db.collection("job_posts").document(postId).setData(newPost) { error in
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
        questions.append("")
    }

    func removeQuestion(at index: Int) {
        questions.remove(at: index)
    }

    private func clearForm() {
        job = ""
        company = ""
        jobType = ""
        qualifications = ""
        preferredQualifications = ""
        deadline = ""
        jobDescription = ""
        URL = ""
        questions = []
        errorMessage = ""
    }
}
