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
                Text("\(post.job)")
                    .font(.title3)
                    .bold()

                Divider()

                // ✅ 자기소개서 문항과 AI의 답변 (키보드 입력 방지)
                ForEach(post.questions.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 20) {
                        Text("질문 \(index + 1): \(post.questions[index])")
                            .font(.headline)
                            .foregroundColor(.black)

                        ZStack(alignment: .topLeading) {
                            if viewModel.aiResponses.indices.contains(index) && viewModel.aiResponses[index].isEmpty {
                                Text("내용을 입력하세요...")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 14)
                                    .padding(.top, 10)
                            }

                            TextEditor(text: Binding(
                                get: { viewModel.aiResponses.indices.contains(index) ? viewModel.aiResponses[index] : "" },
                                set: { _ in } // 입력 방지
                            ))
                            .padding(12)
                            .frame(height: 150)
                            .font(.caption)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView(viewModel.progressText)
                        .padding()
                        .onAppear {
                            viewModel.startProgressTimer()
                        }
                }

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                // ✅ AI 답변 생성 버튼
                Button(action: {
                    viewModel.generateAIResponses(for: post)
                }) {
                    Text("AI 답변 생성")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(.smBlue)
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
                            .background(.smGray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("AI 자기소개서")
    }
}
