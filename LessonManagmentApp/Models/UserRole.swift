//
//  UserRole.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation

/// Represents the type of user accessing the music lesson management system.
///
/// User roles determine which parts of the application a person can access
/// and what actions they are allowed to perform.
enum UserRole: String, Codable {
    case student
    case teacher
}
