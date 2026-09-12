//
//  LocalUserRepository.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import Foundation
import SwiftData

final class LocalUserRepository: UserRepository {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func getAllUsers() -> [User] {

        let descriptor = FetchDescriptor<User>()

        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch users: \(error)")
            return []
        }
    }

    func getStudents() -> [User] {

        getAllUsers().filter {
            $0.role == .student
        }
    }

    func getTeachers() -> [User] {

        getAllUsers().filter {
            $0.role == .teacher
        }
    }

    func addUser(_ user: User) {

        modelContext.insert(user)

        do {
            try modelContext.save()
        } catch {
            print("Failed to save user: \(error)")
        }
    }
}
