//
//  ReviewViewModel.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/15/25.
//

import FirebaseFirestore
import SwiftUI

class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var errorMessage: String = ""

    private let db = Firestore.firestore()

    func fetchReviews() {
        db.collection("reviews")
            .order(by: "createdAt", descending: true)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.errorMessage = "리뷰 로드 실패: \(error.localizedDescription)"
                    } else if let snapshot = snapshot {
                        self?.reviews = snapshot.documents.compactMap { doc -> Review? in
                            let data = doc.data()
                            return Review(
                                job: data["job"] as? String ?? "",
                                jobType: data["jobType"] as? String ?? "",
                                company: data["company"] as? String ?? "",
                                reviewContent: data["reviewContent"] as? String ?? "",
                                questions: (data["questions"] as? [[String: String]])?.compactMap {
                                    Questions(question: $0["question"] ?? "", answer: $0["answer"] ?? "")
                                } ?? []  // ✅ 배열로 변환
                            )
                        }

                    }
                }
            }
    }
}
