//
//  Post.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import Foundation

struct Post: Identifiable {
    let id: String
    let job: String
    let company: String
    let jobType: String
    let qualifications: String
    let preferredQualifications: String
    let deadline: String
    let jobDescription: String
    let URL: String
    let isApplied: Bool
    let createdAt: String
}
