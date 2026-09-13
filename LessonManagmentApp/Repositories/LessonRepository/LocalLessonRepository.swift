//
//  LocalLessonRepository.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation
import SwiftData

final class LocalLessonRepository: LessonRepository {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func getAllLessons() -> [Lesson] {

        let descriptor = FetchDescriptor<Lesson>()

        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch lessons: \(error)")
            return []
        }
    }

    func getLessons(
        forStudentID studentID: UUID
    ) -> [Lesson] {

        getAllLessons().filter {
            $0.studentID == studentID
        }
    }

    func getLessons(
        forTeacherID teacherID: UUID
    ) -> [Lesson] {

        getAllLessons().filter {
            $0.teacherID == teacherID
        }
    }

    func addLesson(_ lesson: Lesson) {

        modelContext.insert(lesson)

        saveContext()
    }

    private func saveContext() {

        do {
            try modelContext.save()
        } catch {
            print("Failed to save lesson: \(error)")
        }
    }
    
    func updateLesson(
        _ lesson: Lesson
    ) {

        do {

            try modelContext.save()

        } catch {

            print(
                "Failed to update lesson: \(error)"
            )
        }
    }
    
    func deleteLesson(
        _ lesson: Lesson
    ) {

        modelContext.delete(
            lesson
        )

        do {

            try modelContext.save()

        } catch {

            print(
                "Failed to delete lesson: \(error)"
            )
        }
    }
}
