//
//  SearchMateTextField.swift
//  SearchMate-iOS
//
//  Created by Seonwoo Kim on 2/12/25.
//

import SwiftUI

struct SearchMateTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var textColor: Color = .black
    var placeholderColor: Color = .gray
    var backgroundColor: Color = .white
    var borderColor: Color = .gray
    var cornerRadius: CGFloat = 8
    var padding: CGFloat = 24
    var frameHeight: CGFloat = 44

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
                    .padding(.horizontal, padding)
                    .font(.caption)
            }

            if isSecure {
                SecureField("", text: $text)
                    .padding(padding)
                    .foregroundColor(textColor)
                    .font(.caption)
            } else {
                TextField("", text: $text)
                    .padding(padding)
                    .foregroundColor(textColor)
                    .font(.caption)
            }
        }
        .frame(height: frameHeight)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .tint(.black)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: 1)
        )
    }
}
