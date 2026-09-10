//
//  User.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation

/// Represents a person who has an account in the music lesson management system.
///
/// A user may be a student or teacher.
/// Their role determines the features and actions available to them.
///
/// Business Rules:
/// - Every user must have a unique identifier.
/// - Every user must have a name and email address.
/// - Every user must be assigned a valid role.
struct User: Identifiable, Codable {

    let id: UUID
    let name: String
    let email: String
    let role: UserRole
}
