//
//  CreateResumeViewModel.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import FirebaseFirestore
import SwiftUI

class CreateResumeViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var skills: String = "" // 쉼표로 구분된 문자열
    @Published var workExperience: String = ""
    @Published var education: String = ""
    @Published var certifications: String = ""
    @Published var projects: String = ""
    @Published var freeTopic: String = ""
    @Published var errorMessage: String = ""
    @Published var isSubmitted: Bool = false

    private let db = Firestore.firestore()

    func createResume() {
        guard !name.isEmpty, !skills.isEmpty, !workExperience.isEmpty, !education.isEmpty, !certifications.isEmpty, !projects.isEmpty else {
            errorMessage = "모든 필드를 입력해주세요."
            return
        }

        let resume = Resume(
            id: UUID().uuidString,
            userId: "exampleUserId", // 실제 사용자 ID 사용 필요
            name: name,
            skills: skills.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) },
            workExperience: workExperience,
            education: education,
            certifications: certifications,
            projects: projects,
            freeTopic: freeTopic,
            createdAt: Date()
        )

        do {
            let resumeData = try Firestore.Encoder().encode(resume)
            db.collection("resume_posts").document(resume.id).setData(resumeData) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = "저장 실패: \(error.localizedDescription)"
                    } else {
                        self.isSubmitted = true
                        self.clearForm()
                    }
                }
            }
        } catch {
            errorMessage = "데이터 인코딩 실패: \(error.localizedDescription)"
        }
    }

    private func clearForm() {
        name = ""
        skills = ""
        workExperience = ""
        education = ""
        certifications = ""
        projects = ""
        freeTopic = ""
        errorMessage = ""
    }
}
