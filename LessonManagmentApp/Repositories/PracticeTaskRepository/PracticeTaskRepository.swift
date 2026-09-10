//
//  PracticeTaskRepository.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import Foundation

/// Defines the operations required for accessing practice task data
/// in the music lesson management system.
protocol PracticeTaskRepository {

    func getAllTasks() -> [PracticeTask]

    func getTasks(forStudentID studentID: UUID) -> [PracticeTask]

    func addTask(_ task: PracticeTask)

    func updateTask(_ task: PracticeTask)
}
