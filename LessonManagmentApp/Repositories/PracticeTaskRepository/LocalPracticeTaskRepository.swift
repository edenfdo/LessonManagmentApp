//
//  LocalPracticeTaskRepository.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation

/// Stores and retrieves practice task data locally while the application is running.
class LocalPracticeTaskRepository: PracticeTaskRepository {

    private var tasks: [PracticeTask] = []

    func getAllTasks() -> [PracticeTask] {
        return tasks
    }

    func getTasks(forStudentID studentID: UUID) -> [PracticeTask] {
        return tasks.filter { task in
            task.studentID == studentID
        }
    }

    func addTask(_ task: PracticeTask) {
        tasks.append(task)
    }

    func updateTask(_ task: PracticeTask) {

        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
}
