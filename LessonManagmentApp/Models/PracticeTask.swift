//
//  PracticeTask.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation

/// Represents a practice activity assigned by a music teacher to a student.
///
/// Practice tasks help students understand what they should work on
/// between lessons and allow progress to be tracked.
///
/// Business Rules:
/// - Every task must belong to a student.
/// - Every task must be assigned by a teacher.
/// - Every task must have a title.
/// - A task can be marked as completed by the assigned student.
struct PracticeTask: Identifiable, Codable {

    let id: UUID
    let title: String
    let description: String

    let studentID: UUID
    let teacherID: UUID

    let dueDate: Date?
    var isCompleted: Bool
}
