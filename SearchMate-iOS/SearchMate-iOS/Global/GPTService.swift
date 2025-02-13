//
//  GPTService.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/13/25.
//

import Foundation

class GPTService {
    private let apiKey = Bundle.main.infoDictionary?["AI_KEY"] as? String ?? ""
    private let apiURL = "https://api.openai.com/v1/chat/completions"

    struct GPTRequest: Codable {
        let model: String
        let messages: [[String: String]]
        let temperature: Double
    }

    struct GPTResponse: Codable {
        let choices: [Choice]
    }

    struct Choice: Codable {
        let message: GPTMessage
    }

    struct GPTMessage: Codable {
        let content: String
    }

    func requestGPTResponse(prompts: [String]) async throws -> [String] {
        guard !apiKey.isEmpty else {
            throw URLError(.userAuthenticationRequired)
        }

        var responses: [String] = []

        for (index, prompt) in prompts.enumerated() {
            let messages: [[String: String]] = [
                ["role": "system", "content": "You are an AI assistant."]
            ] + [["role": "user", "content": prompt]]

            print("📨 [\(index+1)/\(prompts.count)] Sending prompt: \(prompt)")

            let requestBody = GPTRequest(model: "gpt-4", messages: messages, temperature: 0.7)

            guard let url = URL(string: apiURL) else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(requestBody)

            do {
                let (data, response) = try await withCheckedThrowingContinuation { continuation in
                    Task {
                        // ⏳ 요청이 진행되는 동안 로딩 메시지 출력
                        var loadingCounter = 0
                        let loadingTask = Task {
                            while !Task.isCancelled {
                                loadingCounter += 1
                                print("⏳ AI 응답 생성 중... [\(loadingCounter)]")
                                try await Task.sleep(nanoseconds: 1_000_000_000) // 1초마다 메시지 출력
                            }
                        }

                        do {
                            let (data, response) = try await URLSession.shared.data(for: request)
                            loadingTask.cancel() // 성공하면 로딩 메시지 중단
                            continuation.resume(returning: (data, response))
                        } catch {
                            loadingTask.cancel() // 실패하면 로딩 메시지 중단
                            continuation.resume(throwing: error)
                        }
                    }
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.cannotParseResponse)
                }

                print("📡 HTTP Status Code: \(httpResponse.statusCode)")

                if httpResponse.statusCode == 429 {
                    print("⚠️ 429 Too Many Requests: 대기 중...")
                    try await Task.sleep(nanoseconds: 2_000_000_000) // 2초 대기 후 재시도
                    continue
                }

                guard httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }

                let decodedResponse = try JSONDecoder().decode(GPTResponse.self, from: data)
                let responseText = decodedResponse.choices.first?.message.content ?? "응답 없음"
                
                print("✅ AI 응답: \(responseText)")
                responses.append(responseText)

                // 요청 간 1초 대기 (429 오류 방지)
                try await Task.sleep(nanoseconds: 0_100_000_000)
            } catch {
                print("🚨 GPT 요청 실패: \(error.localizedDescription)")
            }
        }

        return responses
    }
}
