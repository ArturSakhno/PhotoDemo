//
//  ViewModifier+Extension.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 31.07.2022.
//

import SwiftUI

extension ViewModifier {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
