//
//  GPTService.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/13/25.
//

import Foundation

class GPTService {
    private let apiKey = Bundle.main.infoDictionary?["AI_KEY"] as! String
    
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
        let messages = prompts.map { ["role": "user", "content": $0] }
        let requestBody = GPTRequest(model: "gpt-4", messages: messages, temperature: 0.7)

        guard let url = URL(string: apiURL) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(GPTResponse.self, from: data)
        return decodedResponse.choices.map { $0.message.content }
    }
}
