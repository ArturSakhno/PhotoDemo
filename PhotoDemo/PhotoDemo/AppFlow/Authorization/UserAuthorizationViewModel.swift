//
//  UserAuthorizationViewModel.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 31.07.2022.
//

import Foundation

final class UserAuthorizationViewModel: ObservableObject {
    @Published var input = "" {
        didSet {
            isSubmitDisabled = input.isEmpty
        }
    }
    @Published var isSubmitDisabled = true

    private unowned var userService = DIContainer.shared.resolve(type: UserServiceInterface.self)

    func onInputChange() {
        input = input.filter(\.isNumber)
        userService.updateUserID(input)
    }
}
