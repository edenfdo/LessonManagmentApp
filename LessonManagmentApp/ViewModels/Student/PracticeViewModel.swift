//
//  PracticeViewModel.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 6/9/2026.
//

import Foundation
import Combine

class PracticeViewModel: ObservableObject {

    @Published var practiceTasks: [PracticeTask] = []
    @Published var lessons: [Lesson] = []

    private let practiceTaskRepository: PracticeTaskRepository
    private let lessonRepository: LessonRepository

    init(
        practiceTaskRepository: PracticeTaskRepository,
        lessonRepository: LessonRepository
    ) {

        self.practiceTaskRepository =
            practiceTaskRepository

        self.lessonRepository =
            lessonRepository
    }

    func loadTasks(
        for studentID: UUID
    ) {

        practiceTasks =
            practiceTaskRepository
                .getTasks(
                    forStudentID: studentID
                )

        lessons =
            lessonRepository
                .getLessons(
                    forStudentID: studentID
                )
    }

    func toggleTaskCompletion(
        _ task: PracticeTask
    ) {

        task.isCompleted.toggle()

        practiceTaskRepository.updateTask(
            task
        )
    }

    var completedTaskCount: Int {

        practiceTasks
            .filter {
                $0.isCompleted
            }
            .count
    }

    var progress: Double {

        guard !practiceTasks.isEmpty else {
            return 0
        }

        return Double(
            completedTaskCount
        )
        /
        Double(
            practiceTasks.count
        )
    }

    func lessonForTask(
        _ task: PracticeTask
    ) -> Lesson? {

        lessons.first {
            $0.id == task.lessonID
        }
    }
}
