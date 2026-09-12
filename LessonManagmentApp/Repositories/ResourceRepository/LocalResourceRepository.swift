//
//  LocalResourceRepository.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import Foundation
import SwiftData

final class LocalResourceRepository:
    ResourceRepository {

    private let modelContext: ModelContext

    init(
        modelContext: ModelContext
    ) {
        self.modelContext = modelContext
    }

    func getAllResources()
    -> [Resource] {

        let descriptor =
            FetchDescriptor<Resource>()

        do {

            return try modelContext.fetch(
                descriptor
            )

        } catch {

            print(
                "Failed to fetch resources: \(error)"
            )

            return []
        }
    }

    func getResources(
        forStudentID studentID: UUID
    ) -> [Resource] {

        getAllResources().filter {
            $0.studentID == studentID
        }
    }

    func getResources(
        forTeacherID teacherID: UUID
    ) -> [Resource] {

        getAllResources().filter {
            $0.teacherID == teacherID
        }
    }

    func addResource(
        _ resource: Resource
    ) {

        modelContext.insert(
            resource
        )

        saveContext()
    }

    private func saveContext() {

        do {

            try modelContext.save()

        } catch {

            print(
                "Failed to save resource: \(error)"
            )
        }
    }
}
