//
//  GPTService.swift
//  SearchMate-iOS
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
            print("🚨 API Key가 설정되지 않았습니다!")
            throw URLError(.userAuthenticationRequired)
        }

        print("📝 요청된 프롬프트 개수: \(prompts.count)")

        var responses: [String] = []

        for prompt in prompts {
            let messages: [[String: String]] = [
                ["role": "system", "content": "You are an AI assistant. 사용자의 이력서를 참고하여 자기소개서 문항에 대한 답변을 생성하세요."],
                ["role": "user", "content": prompt]
            ]

            let requestBody = GPTRequest(model: "gpt-4o", messages: messages, temperature: 0.7)

            guard let url = URL(string: apiURL) else {
                print("🚨 API URL이 잘못되었습니다!")
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(requestBody)

            print("📡 OpenAI API 요청 시작...")

            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("🚨 응답을 파싱할 수 없습니다!")
                    throw URLError(.cannotParseResponse)
                }

                print("📡 HTTP Status Code: \(httpResponse.statusCode)")

                if httpResponse.statusCode == 200 {
                    let decodedResponse = try JSONDecoder().decode(GPTResponse.self, from: data)
                    let responseText = decodedResponse.choices.first?.message.content ?? "응답 없음"
                    responses.append(responseText)
                    print("✅ GPT 응답: \(responseText)")
                } else {
                    print("🚨 API 요청 실패 - 상태 코드: \(httpResponse.statusCode)")
                    throw URLError(.badServerResponse)
                }
            } catch {
                print("🚨 GPT 요청 실패: \(error.localizedDescription)")
                throw error
            }
        }

        return responses
    }
}
