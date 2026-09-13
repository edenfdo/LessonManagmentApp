//
//  LoginViewModel.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""

    private let userRepository: UserRepository

    init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    func login() -> User? {

        errorMessage = ""

        let cleanedEmail =
            email
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                .lowercased()

        let users =
            userRepository.getAllUsers()

        let matchingUser =
            users.first { user in

                user.email.lowercased()
                    == cleanedEmail
                &&
                PasswordHasher.verify(
                    password: password,
                    hash: user.passwordHash
                )
            }

        if let matchingUser {
            return matchingUser
        }

        errorMessage =
            "Email or password is incorrect. Please check your details and try again."

        return nil
    }
}
