//
//  SettingsViewModel.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import Foundation
import Combine

final class SettingsViewModel: ObservableObject {

    @Published var errorMessage = ""
    @Published var successMessage = ""

    private let userRepository: UserRepository

    init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    func changePassword(
        user: User,
        currentPassword: String,
        newPassword: String,
        confirmPassword: String
    ) -> Bool {

        errorMessage = ""
        successMessage = ""

        guard PasswordHasher.verify(
            password: currentPassword,
            hash: user.passwordHash
        ) else {

            errorMessage =
                "Current password is incorrect."

            return false
        }

        guard newPassword.count >= 6 else {

            errorMessage =
                "New password must be at least 6 characters."

            return false
        }

        guard newPassword == confirmPassword else {

            errorMessage =
                "New passwords do not match."

            return false
        }

        user.passwordHash =
            PasswordHasher.hash(
                newPassword
            )

        userRepository.updateUser(
            user
        )

        successMessage =
            "Password changed successfully."

        return true
    }
}
