//
//  HideKeyboard.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 31.07.2022.
//

import SwiftUI

struct HideKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.background
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

                content
        }
        .onTapGesture {
            endEditing()
        }
    }
}

extension View {
    func hideKeyboard() -> some View {
        modifier(HideKeyboard())
    }
}

