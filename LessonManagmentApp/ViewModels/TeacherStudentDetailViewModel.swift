//
//  TeacherStudentDetailViewModel.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import Foundation
import Combine

final class TeacherStudentDetailViewModel: ObservableObject {

    @Published var lessons: [Lesson] = []
    @Published var practiceTasks: [PracticeTask] = []

    private let lessonRepository: LessonRepository
    private let practiceTaskRepository: PracticeTaskRepository

    init(
        lessonRepository: LessonRepository,
        practiceTaskRepository: PracticeTaskRepository
    ) {
        self.lessonRepository = lessonRepository
        self.practiceTaskRepository = practiceTaskRepository
    }

    func loadStudentData(
        studentID: UUID
    ) {

        lessons =
            lessonRepository
                .getLessons(
                    forStudentID: studentID
                )

        practiceTasks =
            practiceTaskRepository
                .getTasks(
                    forStudentID: studentID
                )
    }

    var upcomingLesson: Lesson? {

        lessons
            .filter {
                $0.date >= Date()
            }
            .sorted {
                $0.date < $1.date
            }
            .first
    }
}
