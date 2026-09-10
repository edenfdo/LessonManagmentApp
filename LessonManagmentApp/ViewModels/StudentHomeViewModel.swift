//
//  HomeViewModel.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 6/9/2026.
//

import Foundation
import Combine

/// Provides lesson and practice information for the student Home screen.
class StudentHomeViewModel: ObservableObject {

    @Published var upcomingLesson: Lesson?
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

    func loadHomeData(for studentID: UUID) {

        let studentLessons =
            lessonRepository.getLessons(forStudentID: studentID)

        upcomingLesson = studentLessons
            .filter { $0.date >= Date() }
            .sorted { $0.date < $1.date }
            .first

        practiceTasks =
            practiceTaskRepository.getTasks(forStudentID: studentID)
    }
    
    func toggleTaskCompletion(_ task: PracticeTask) {

        var updatedTask = task
        updatedTask.isCompleted.toggle()

        practiceTaskRepository.updateTask(updatedTask)

        if let index = practiceTasks.firstIndex(
            where: { $0.id == updatedTask.id }
        ) {
            practiceTasks[index] = updatedTask
        }
    }

    var progress: Double {

        guard !practiceTasks.isEmpty else {
            return 0
        }

        let completedTasks =
            practiceTasks.filter { $0.isCompleted }.count

        return Double(completedTasks) /
               Double(practiceTasks.count)
    }
}
