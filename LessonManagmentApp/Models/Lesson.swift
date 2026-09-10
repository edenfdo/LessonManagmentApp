//
//  Lesson.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation

/// Represents a scheduled music lesson between a student and music teacher.
///
/// A lesson contains the information required by students and teachers
/// to identify when and where the lesson takes place and what learning
/// information is associated with it.
///
/// Business Rules:
/// - Every lesson must belong to one student and one teacher.
/// - A lesson must have a scheduled date and time.
/// - Lesson information should only be modified by an authorised teacher or administrator.
struct Lesson: Identifiable, Codable {

    let id: UUID
    let title: String
    let date: Date

    let studentID: UUID
    let teacherID: UUID

    let notes: String
    let location: String
}

