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

    private let practiceTaskRepository: PracticeTaskRepository

    init(practiceTaskRepository: PracticeTaskRepository) {
        self.practiceTaskRepository = practiceTaskRepository
    }

    func loadTasks(for studentID: UUID) {
        practiceTasks =
            practiceTaskRepository.getTasks(forStudentID: studentID)
    }

    func toggleTaskCompletion(_ task: PracticeTask) {

        task.isCompleted.toggle()

        practiceTaskRepository.updateTask(task)
    }

    var completedTaskCount: Int {
        practiceTasks.filter { $0.isCompleted }.count
    }

    var progress: Double {

        guard !practiceTasks.isEmpty else {
            return 0
        }

        return Double(completedTaskCount)
            / Double(practiceTasks.count)
    }
}
