//
//  AIView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

//
//  AIView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import SwiftUI

struct AIView: View {
    let post: Post
    @StateObject private var viewModel = AIViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("\(post.job) - AI 기반 자기소개서 작성")
                    .font(.title)
                    .bold()
                    .padding()

                Divider()

                // ✅ 자기소개서 문항과 AI의 답변
                ForEach(post.questions.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("질문 \(index + 1): \(post.questions[index])")
                            .font(.headline)

                        TextEditor(text: Binding(
                            get: { viewModel.aiResponses.indices.contains(index) ? viewModel.aiResponses[index] : "" },
                            set: { if viewModel.aiResponses.indices.contains(index) { viewModel.aiResponses[index] = $0 } }
                        ))
                        .frame(height: 150)
                        .border(Color.gray, width: 1)
                        .padding(.horizontal)
                    }
                }

                // ✅ AI 답변 생성 버튼
                Button(action: {
                    viewModel.generateAIResponses(for: post)
                }) {
                    Text("AI 답변 생성")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }

                // ✅ URL로 이동하기 버튼
                if let postURL = URL(string: post.URL), UIApplication.shared.canOpenURL(postURL) {
                    Button(action: {
                        UIApplication.shared.open(postURL)
                    }) {
                        Text("URL로 이동하기")
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding()
                    }
                }

                if viewModel.isLoading {
                    ProgressView("AI 답변 생성 중...")
                        .padding()
                }

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle("AI 작성 보기")
    }
}
