//
//  Resume.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import Foundation

struct Resume: Identifiable, Codable {
    let id: String
    let userId: String
    let name: String
    let skills: [String]
    let workExperience: String
    let education: String
    let certifications: String
    let projects: String
    let questions: [String]
    let freeTopic: String
    let createdAt: Date
}
