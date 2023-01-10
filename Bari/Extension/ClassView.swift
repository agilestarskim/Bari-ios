//
//  ConvexViewModi.swift
//  Bari
//
//  Created by 김민성 on 2022/12/20.
//

import SwiftUI

struct ClassView: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .padding()
                .background(.ultraThinMaterial)
                .overlay(
                    LinearGradient(colors: [.clear,.black.opacity(0.2)], startPoint: .top, endPoint: .bottom))
                .cornerRadius(14)
                .shadow(color: .white, radius: 3, x: -1, y: -2)
                .shadow(color: .black, radius: 3, x: 2, y: 2)
        } else {
            // Fallback on earlier versions
            content
                .padding()
                .cornerRadius(14)
                .shadow(color: .white, radius: 3, x: -3, y: -3)
                .shadow(color: .black, radius: 3, x: 3, y: 3)
        }
    }
}
