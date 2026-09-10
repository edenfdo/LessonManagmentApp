//
//  LessonRepository.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation

/// Defines the operations required for accessing lesson data
/// in the music lesson management system.
protocol LessonRepository {

    func getAllLessons() -> [Lesson]

    func getLessons(forStudentID studentID: UUID) -> [Lesson]

    func getLessons(forTeacherID teacherID: UUID) -> [Lesson]

    func addLesson(_ lesson: Lesson)
}
