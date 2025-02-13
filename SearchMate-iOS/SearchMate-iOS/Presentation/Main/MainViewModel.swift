//
//  MainViewModel.swift
//  SearchMate
//
//  Created by Seonwoo Kim on 2/12/25.
//

import FirebaseFirestore
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoadingNextPage = false
    @Published var errorMessage: String = ""

    private let db = Firestore.firestore()
    private var lastDocument: DocumentSnapshot?
    private var isFetching = false
    private let pageSize = 20

    func fetchPosts() {
        guard !isFetching else { return }
        isFetching = true

        let query = db.collection("job_posts")
            .order(by: "createdAt", descending: true)
            .limit(to: pageSize)

        query.getDocuments { [weak self] snapshot, error in
            DispatchQueue.main.async {
                self?.isFetching = false

                if let error = error {
                    self?.errorMessage = "Failed to fetch job posts: \(error.localizedDescription)"
                } else if let snapshot = snapshot {
                    self?.posts = snapshot.documents.compactMap { doc -> Post? in
                        let data = doc.data()
                        return Post(
                            id: doc.documentID,
                            job: data["job"] as? String ?? "",
                            company: data["company"] as? String ?? "",
                            jobType: data["jobType"] as? String ?? "",
                            qualifications: data["qualifications"] as? String ?? "",
                            preferredQualifications: data["preferredQualifications"] as? String ?? "",
                            deadline: data["deadline"] as? String ?? "상시 채용",
                            jobDescription: data["jobDescription"] as? String ?? "",
                            URL: data["URL"] as? String ?? "",
                            questions: data["questions"] as? [String] ?? [],
                            isApplied: data["isApplied"] as? Bool ?? false,
                            createdAt: data["createdAt"] as? String ?? "Unknown date"
                        )
                    }
                    self?.lastDocument = snapshot.documents.last
                }
            }
        }
    }

    func fetchNextPage() {
        guard !isLoadingNextPage, let lastDocument = lastDocument else { return }
        isLoadingNextPage = true

        let query = db.collection("job_posts")
            .order(by: "createdAt", descending: true)
            .start(afterDocument: lastDocument)
            .limit(to: pageSize)

        query.getDocuments { [weak self] snapshot, error in
            DispatchQueue.main.async {
                self?.isLoadingNextPage = false

                if let error = error {
                    self?.errorMessage = "Failed to fetch next page: \(error.localizedDescription)"
                } else if let snapshot = snapshot {
                    let newPosts = snapshot.documents.compactMap { doc -> Post? in
                        let data = doc.data()
                        return Post(
                            id: doc.documentID,
                            job: data["job"] as? String ?? "",
                            company: data["company"] as? String ?? "",
                            jobType: data["jobType"] as? String ?? "",
                            qualifications: data["qualifications"] as? String ?? "",
                            preferredQualifications: data["preferredQualifications"] as? String ?? "",
                            deadline: data["deadline"] as? String ?? "상시 채용",
                            jobDescription: data["jobDescription"] as? String ?? "",
                            URL: data["URL"] as? String ?? "",
                            isApplied: data["isApplied"] as? Bool ?? false,
                            createdAt: data["createdAt"] as? String ?? "Unknown date"
                        )
                    }

                    self?.posts.append(contentsOf: newPosts)
                    self?.lastDocument = snapshot.documents.last
                }
            }
        }
    }

    func resetPagination() {
        posts = []
        lastDocument = nil
    }
}
