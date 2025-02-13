//
//  TestGPTService.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/13/25.
//

import Foundation

class TestGPTService {
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

    func requestGPTResponse() async throws -> String {
        guard !apiKey.isEmpty else {
            print("🚨 API Key가 설정되지 않았습니다!")
            throw URLError(.userAuthenticationRequired)
        }

        let messages: [[String: String]] = [
            ["role": "system", "content": "You are an AI assistant."],
            ["role": "user", "content": "식사 메뉴를 하나 추천해줘!"]
        ]

        let requestBody = GPTRequest(model: "gpt-4o", messages: messages, temperature: 0.7)

        guard let url = URL(string: apiURL) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.cannotParseResponse)
            }

            print("📡 HTTP Status Code: \(httpResponse.statusCode)")

            guard httpResponse.statusCode == 200 else {
                print("🚨 API 요청 실패 - 상태 코드: \(httpResponse.statusCode)")
                throw URLError(.badServerResponse)
            }

            let decodedResponse = try JSONDecoder().decode(GPTResponse.self, from: data)
            let responseText = decodedResponse.choices.first?.message.content ?? "추천 메뉴 없음"

            print("✅ GPT 응답: \(responseText)")
            return responseText
        } catch {
            print("🚨 GPT 요청 실패: \(error.localizedDescription)")
            throw error
        }
    }
}
