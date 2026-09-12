//
//  User.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation
import SwiftData

@Model
final class User: Identifiable {

    @Attribute(.unique)
    var id: UUID

    var name: String
    var email: String
    var passwordHash: String
    var roleRawValue: String

    var role: UserRole {
        get {
            UserRole(rawValue: roleRawValue) ?? .student
        }

        set {
            roleRawValue = newValue.rawValue
        }
    }

    init(
        id: UUID,
        name: String,
        email: String,
        password: String,
        role: UserRole
    ) {
        self.id = id
        self.name = name
        self.email = email

        self.passwordHash =
            PasswordHasher.hash(
                password
            )

        self.roleRawValue =
            role.rawValue
    }
}
