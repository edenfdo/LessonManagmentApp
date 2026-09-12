//
//  LocalPracticeTaskRepository.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation
import SwiftData

final class LocalPracticeTaskRepository: PracticeTaskRepository {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func getAllTasks() -> [PracticeTask] {

        let descriptor = FetchDescriptor<PracticeTask>()

        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch practice tasks: \(error)")
            return []
        }
    }

    func getTasks(
        forStudentID studentID: UUID
    ) -> [PracticeTask] {

        let allTasks = getAllTasks()

        return allTasks.filter {
            $0.studentID == studentID
        }
    }

    func addTask(
        _ task: PracticeTask
    ) {

        modelContext.insert(task)

        saveContext()
    }

    func updateTask(
        _ task: PracticeTask
    ) {

        saveContext()
    }

    private func saveContext() {

        do {
            try modelContext.save()
        } catch {
            print(
                "Failed to save practice tasks: \(error)"
            )
        }
    }
}
