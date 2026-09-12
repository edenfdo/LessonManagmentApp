//
//  StudentResourcesViewModel.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import Foundation
import Combine

final class StudentResourcesViewModel: ObservableObject {

    @Published var resources: [Resource] = []

    private let resourceRepository: ResourceRepository

    init(
        resourceRepository: ResourceRepository
    ) {
        self.resourceRepository = resourceRepository
    }

    func loadResources(
        studentID: UUID
    ) {

        resources =
            resourceRepository
                .getResources(
                    forStudentID: studentID
                )
    }
}
