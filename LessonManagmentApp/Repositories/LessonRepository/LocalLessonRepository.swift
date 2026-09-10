//
//  LocalLessonRepository.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation

/// Stores and retrieves lesson data locally while the application is running.
class LocalLessonRepository: LessonRepository {

    private var lessons: [Lesson] = []

    func getAllLessons() -> [Lesson] {
        return lessons
    }

    func getLessons(forStudentID studentID: UUID) -> [Lesson] {
        return lessons.filter { lesson in
            lesson.studentID == studentID
        }
    }

    func getLessons(forTeacherID teacherID: UUID) -> [Lesson] {
        return lessons.filter { lesson in
            lesson.teacherID == teacherID
        }
    }

    func addLesson(_ lesson: Lesson) {
        lessons.append(lesson)
    }
}
