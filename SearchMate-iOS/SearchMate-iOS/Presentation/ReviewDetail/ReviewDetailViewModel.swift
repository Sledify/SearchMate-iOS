//
//  ReviewDetailViewModel.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/15/25.
//

import SwiftUI

class ReviewDetailViewModel: ObservableObject {
    @Published var review: Review?

    func loadReview(_ review: Review) {
        DispatchQueue.main.async {
            self.review = review
        }
    }
}
