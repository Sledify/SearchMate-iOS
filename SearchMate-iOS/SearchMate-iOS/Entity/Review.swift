//
//  Review.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/15/25.
//

import Foundation

struct Review: Identifiable {
    let id = UUID()
    let job: String
    let jobType: String
    let company: String
    let reviewContent: String
    let questions: [Questions]
}

struct Questions {
    var question: String
    var answer: String
}
