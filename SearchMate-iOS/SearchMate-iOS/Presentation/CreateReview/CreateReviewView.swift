//
//  CreateReviewView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/15/25.
//

import SwiftUI

struct CreateReviewView: View {
    @StateObject private var viewModel = CreateReviewViewModel()
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 50) {
                    Text("합격 리뷰 작성")
                        .font(.title)
                        .foregroundColor(.black)
                        .bold()
                    
                    VStack(spacing: 20) {
                        SearchMateTextField(placeholder: "직무", text: $viewModel.job)
                        SearchMateTextField(placeholder: "회사명", text: $viewModel.company)
                        SearchMateTextField(placeholder: "고용 형태", text: $viewModel.jobType)
                        SearchMateTextField(placeholder: "리뷰 내용", text: $viewModel.reviewContent)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("자기소개서 문항")
                                .font(.headline)
                            
                            ForEach(viewModel.questions.indices, id: \.self) { index in
                                HStack {
                                    TextField("질문", text: $viewModel.questions[index].question)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.horizontal)

                                    TextField("답변", text: $viewModel.questions[index].answer)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.horizontal)

                                    Button(action: {
                                        viewModel.removeQuestion(at: index)
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            
                            Button(action: {
                                viewModel.addQuestion()
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("질문 추가")
                                }
                                .foregroundColor(.smBlue)
                            }
                        }
                    }
                    
                    Button(action: {
                        viewModel.createReview()
                    }) {
                        Text("리뷰 등록하기")
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(.smBlue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    if viewModel.isSubmitted {
                        Text("리뷰가 등록되었습니다!")
                            .foregroundColor(.smGray)
                    }

                    Spacer().frame(height: 100) // 키보드 여백 추가
                }
                .padding()
            }
        }
    }
}
