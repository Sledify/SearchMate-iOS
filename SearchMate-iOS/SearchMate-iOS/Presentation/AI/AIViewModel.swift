//
//  AIViewModel.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import FirebaseFirestore
import SwiftUI

class AIViewModel: ObservableObject {
    @Published var aiResponses: [String] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private let db = Firestore.firestore()
    private let gptService = GPTService()

    init() {
        self.aiResponses = []
    }

    func generateAIResponses(for post: Post) {
        isLoading = true
        errorMessage = ""

        // ✅ Firestore에서 사용자의 최신 Resume 가져오기
        fetchResume { [weak self] resume in
            guard let self = self, let resume = resume else {
                DispatchQueue.main.async {
                    self?.errorMessage = "이력서를 불러올 수 없습니다."
                    self?.isLoading = false
                }
                return
            }

            // ✅ GPT에게 요청할 질문 구성
            let resumeSummary = self.formatResumeForAI(resume)
            let prompts = post.questions.map { question in
                return """
                질문: \(question)
                사용자 이력서 정보:
                \(resumeSummary)
                
                답변:
                """
            }

            // ✅ GPT API 호출
            self.callGPT(prompts: prompts)
        }
    }

    /// ✅ Firestore에서 현재 로그인된 사용자의 최신 Resume 가져오기
    private func fetchResume(completion: @escaping (Resume?) -> Void) {
        guard let userId = AuthManager.shared.getCurrentUserId() else {
            print("사용자가 로그인되지 않았습니다.")
            completion(nil)
            return
        }

        db.collection("resume_posts")
            .whereField("userId", isEqualTo: userId)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Resume 가져오기 실패: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let document = snapshot?.documents.first else {
                    completion(nil)
                    return
                }

                do {
                    let resume = try document.data(as: Resume.self)
                    completion(resume)
                } catch {
                    print("Resume 데이터 변환 실패: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    /// ✅ Resume 정보를 AI에게 적합한 텍스트 포맷으로 변환
    private func formatResumeForAI(_ resume: Resume) -> String {
        return """
        이름: \(resume.name)
        보유 기술: \(resume.skills.joined(separator: ", "))
        경력 사항: \(resume.workExperience)
        학력 사항: \(resume.education)
        자격증: \(resume.certifications)
        프로젝트 경험: \(resume.projects)
        프리 토픽: \(resume.freeTopic)
        """
    }

    /// ✅ GPT API 호출
    private func callGPT(prompts: [String]) {
        Task {
            do {
                // ✅ GPT API 요청
                let responses = try await self.gptService.requestGPTResponse(prompts: prompts)

                DispatchQueue.main.async {
                    self.aiResponses = responses
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "AI 응답 생성 실패: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}
    
