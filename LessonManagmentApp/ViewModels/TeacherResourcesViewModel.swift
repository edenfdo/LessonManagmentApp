//
//  TeacherResourcesViewModel.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import Foundation
import Combine

final class TeacherResourcesViewModel: ObservableObject {

    @Published var resources: [Resource] = []
    @Published var students: [User] = []
    
    @Published var lessons: [Lesson] = []
    
    private let lessonRepository: LessonRepository

    private let resourceRepository: ResourceRepository
    private let userRepository: UserRepository

    init(
        resourceRepository: ResourceRepository,
        userRepository: UserRepository,
        lessonRepository: LessonRepository
    ) {
        self.resourceRepository = resourceRepository
        self.userRepository = userRepository
        self.lessonRepository = lessonRepository
    }

    // MARK: - Load Data

    func loadData(
        teacherID: UUID
    ) {

        students =
            userRepository.getStudents()

        lessons =
            lessonRepository
                .getLessons(
                    forTeacherID: teacherID
                )
                .sorted {
                    $0.date < $1.date
                }

        resources =
            resourceRepository
                .getResources(
                    forTeacherID: teacherID
                )
                .sorted {
                    $0.datePosted > $1.datePosted
                }
    }

    // MARK: - Add Resource

    func addResource(
        title: String,
        selectedFileURL: URL,
        studentID: UUID,
        lessonID: UUID?,
        teacher: User
    ) throws {

        let resourceID = UUID()

        let accessing =
            selectedFileURL
                .startAccessingSecurityScopedResource()

        defer {
            if accessing {
                selectedFileURL
                    .stopAccessingSecurityScopedResource()
            }
        }

        let savedFileName =
            try ResourceFileStorage
                .saveFile(
                    from: selectedFileURL,
                    resourceID: resourceID
                )

        let fileType =
            determineFileType(
                url: selectedFileURL
            )

        let resource = Resource(
            id: resourceID,
            title: title,
            teacherID: teacher.id,
            studentID: studentID,
            lessonID: lessonID,
            teacherName: teacher.name,
            datePosted: Date(),
            fileName: savedFileName,
            fileType: fileType
        )

        resourceRepository.addResource(
            resource
        )

        loadData(
            teacherID: teacher.id
        )
    }

    // MARK: - Find Student

    func studentForResource(
        _ resource: Resource
    ) -> User? {

        students.first {
            $0.id == resource.studentID
        }
    }

    // MARK: - File Type

    func determineFileType(
        url: URL
    ) -> ResourceFileType {

        if url.pathExtension
            .lowercased() == "pdf" {

            return .pdf
        }

        return .image
    }
    
    func lessonsForStudent(
        studentID: UUID
    ) -> [Lesson] {

        lessons.filter {
            $0.studentID == studentID
        }
    }
}

