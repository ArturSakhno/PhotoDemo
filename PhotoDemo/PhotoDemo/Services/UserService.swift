//
//  UserService.swift
//  PhotoDemo
//
//  Created by Artur Sakhno on 02.08.2022.
//

import Foundation

protocol UserServiceInterface: AnyObject {
    var userId: String { get }

    func updateUserID(_ input: String)
}

final class UserService: UserServiceInterface {
    var userId = ""
    
    func updateUserID(_ input: String) {
        userId = input
    }
}
