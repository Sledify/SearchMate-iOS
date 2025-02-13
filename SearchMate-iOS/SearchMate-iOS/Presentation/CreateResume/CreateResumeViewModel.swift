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

    /// ✅ 현재 로그인된 사용자의 UID 가져오기 (AuthManager 활용)
    private var currentUserId: String? {
        return AuthManager.shared.getCurrentUserId()
    }

    /// ✅ 이력서 생성 또는 업데이트 (유저당 1개 제한)
    func createOrUpdateResume() {
        guard let userId = currentUserId else {
            errorMessage = "사용자가 로그인되지 않았습니다."
            return
        }

        guard !name.isEmpty, !skills.isEmpty, !workExperience.isEmpty, !education.isEmpty, !certifications.isEmpty, !projects.isEmpty else {
            errorMessage = "모든 필드를 입력해주세요."
            return
        }

        let skillsArray = skills.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        db.collection("resume_posts")
            .whereField("userId", isEqualTo: userId)
            .limit(to: 1)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "이력서 불러오기 실패: \(error.localizedDescription)"
                    }
                    return
                }

                if let document = snapshot?.documents.first {
                    // ✅ 기존 이력서가 존재하면 업데이트
                    self.updateResume(documentId: document.documentID, skillsArray: skillsArray, userId: userId)
                } else {
                    // ✅ 새 이력서 저장
                    self.createNewResume(skillsArray: skillsArray, userId: userId)
                }
            }
    }

    /// ✅ 기존 이력서 업데이트
    private func updateResume(documentId: String, skillsArray: [String], userId: String) {
        let updatedData: [String: Any] = [
            "userId": userId,
            "name": name,
            "skills": skillsArray,
            "workExperience": workExperience,
            "education": education,
            "certifications": certifications,
            "projects": projects,
            "freeTopic": freeTopic,
            "updatedAt": Timestamp(date: Date())
        ]

        db.collection("resume_posts").document(documentId).updateData(updatedData) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "이력서 업데이트 실패: \(error.localizedDescription)"
                } else {
                    self.isSubmitted = true
                    self.clearForm()
                }
            }
        }
    }

    /// ✅ 새 이력서 저장
    private func createNewResume(skillsArray: [String], userId: String) {
        let resumeId = UUID().uuidString
        let newResume: [String: Any] = [
            "id": resumeId,
            "userId": userId,
            "name": name,
            "skills": skillsArray,
            "workExperience": workExperience,
            "education": education,
            "certifications": certifications,
            "projects": projects,
            "freeTopic": freeTopic,
            "createdAt": Timestamp(date: Date())
        ]

        db.collection("resume_posts").document(resumeId).setData(newResume) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "이력서 저장 실패: \(error.localizedDescription)"
                } else {
                    self.isSubmitted = true
                    self.clearForm()
                }
            }
        }
    }

    /// ✅ 입력 폼 초기화
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
