//
//  CalendarViewModel.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 6/9/2026.
//

import Foundation
import Combine

/// Provides lesson information for the student Calendar screen.
class CalendarViewModel: ObservableObject {

    @Published var lessons: [Lesson] = []
    @Published var selectedDate: Date = Date()

    private let lessonRepository: LessonRepository

    init(lessonRepository: LessonRepository) {
        self.lessonRepository = lessonRepository
    }

    // Loads all lessons belonging to the student
    func loadLessons(for studentID: UUID) {

        lessons = lessonRepository
            .getLessons(forStudentID: studentID)
            .sorted { $0.date < $1.date }
    }

    // Finds lessons that occur on a selected date
    func lessons(for date: Date) -> [Lesson] {

        lessons.filter { lesson in
            Calendar.current.isDate(
                lesson.date,
                inSameDayAs: date
            )
        }
    }
}
