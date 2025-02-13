//
//  AIViewModel.swift
//  SearchMate-iOS
//

import FirebaseFirestore
import SwiftUI

class AIViewModel: ObservableObject {
    @Published var aiResponses: [String] = ["", "", "", ""]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private let db = Firestore.firestore()
    private let gptService = GPTService()

    func generateAIResponses(for post: Post) {
        isLoading = true
        errorMessage = ""
        
        print("🟢 AI 응답 생성 시작!")

        fetchResume { [weak self] resume in
            guard let self = self, let resume = resume else {
                DispatchQueue.main.async {
                    self?.errorMessage = "이력서를 불러올 수 없습니다."
                    self?.isLoading = false
                }
                print("🚨 이력서 로드 실패")
                return
            }

            let resumeSummary = self.formatResumeForAI(resume)
            print("✅ 이력서 로드 성공:\n\(resumeSummary)")

            let prompts = post.questions.map { question in
                """
                [취업 자기소개서 문항]
                질문: \(question)
                
                [사용자의 이력서 정보]
                \(resumeSummary)

                [응답 가이드]
                - 해당 질문에 대한 취업 자기소개서 답변을 작성하세요.
                - 500자 내외로 답변하세요.
                - 명확하고 구체적인 사례를 포함하세요.

                답변:
                """
            }

            print("📨 AI 요청 생성 중... 요청 개수: \(prompts.count)")

            self.callGPT(prompts: prompts)
        }
    }

    /// ✅ Firestore에서 현재 로그인된 사용자의 최신 Resume 가져오기
    private func fetchResume(completion: @escaping (Resume?) -> Void) {
        guard let userId = AuthManager.shared.getCurrentUserId() else {
            DispatchQueue.main.async {
                self.errorMessage = "사용자가 로그인되지 않았습니다."
                self.isLoading = false
            }
            print("🚨 로그인된 사용자 없음")
            completion(nil)
            return
        }

        print("🔍 Firestore에서 이력서 검색 중... userId: \(userId)")

        db.collection("resume_posts")
            .whereField("userId", isEqualTo: userId)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "이력서 가져오기 실패: \(error.localizedDescription)"
                        self.isLoading = false
                    }
                    print("🚨 이력서 가져오기 실패: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let document = snapshot?.documents.first else {
                    DispatchQueue.main.async {
                        self.errorMessage = "이력서가 존재하지 않습니다."
                        self.isLoading = false
                    }
                    print("🚨 Firestore에서 해당 사용자의 이력서를 찾을 수 없음")
                    completion(nil)
                    return
                }

                do {
                    let resume = try document.data(as: Resume.self)
                    print("✅ Firestore에서 이력서 로드 성공!")
                    completion(resume)
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "이력서 변환 실패: \(error.localizedDescription)"
                        self.isLoading = false
                    }
                    print("🚨 Firestore 데이터 변환 실패: \(error.localizedDescription)")
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
                print("🔵 GPT API 호출 시작")
                let responses = try await gptService.requestGPTResponse(prompts: prompts)

                DispatchQueue.main.async {
                    self.aiResponses = responses
                    self.isLoading = false
                }
                print("✅ AI 응답 저장 완료:\n\(responses)")
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "AI 응답 생성 실패: \(error.localizedDescription)"
                    self.isLoading = false
                }
                print("🚨 AI 응답 처리 중 오류 발생: \(error.localizedDescription)")
            }
        }
    }
}
