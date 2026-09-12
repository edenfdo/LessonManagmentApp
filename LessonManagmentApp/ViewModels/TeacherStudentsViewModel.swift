//
//  TeacherStudentsViewModel.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import Foundation
import Combine

final class TeacherStudentsViewModel: ObservableObject {

    @Published var students: [User] = []

    private let userRepository: UserRepository

    init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    func loadStudents() {

        students =
            userRepository.getStudents()
    }

    func addStudent(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) {

        let fullName =
            "\(firstName) \(lastName)"
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

        let student = User(
            id: UUID(),
            name: fullName,
            email: email,
            password: password,
            role: .student
        )

        userRepository.addUser(
            student
        )

        loadStudents()
    }
}
