//
//  MainView.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.posts.indices, id: \.self) { index in
                    let post = viewModel.posts[index]
                    NavigationLink(destination: JobDetailView(post: post)) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(post.job)
                                .font(.headline)
                            Text(post.company)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack {
                                Text(post.jobType)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("마감일: \(post.deadline)")
                                    .font(.footnote)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .onAppear {
                        if index == viewModel.posts.count - 1 {
                            viewModel.fetchNextPage()
                        }
                    }
                }

                if viewModel.isLoadingNextPage {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
            }
            .refreshable {
                viewModel.resetPagination()
                viewModel.fetchPosts()
            }
            .onAppear {
                viewModel.fetchPosts()
            }
            .navigationTitle("채용 공고")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink(destination: CreatePostView()) {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MyPageView()) {
                        Image(systemName: "person.circle")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }

                // ✅ ReviewView로 이동하는 리스트 아이콘 추가
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: ReviewView()) {
                        Image(systemName: "list.bullet.rectangle")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .tint(.black)
    }
}

