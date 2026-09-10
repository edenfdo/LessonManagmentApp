//
//  ContentView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import SwiftUI

struct RootView: View {

    @State private var currentUser: User?

    private let sampleStudent: User
    private let sampleTeacher: User

    private let lessonRepository: LocalLessonRepository
    private let practiceTaskRepository: LocalPracticeTaskRepository

    init() {

        // Create sample users first
        let student = User(
            id: UUID(),
            name: "Mia",
            email: "mia@email.com",
            role: .student
        )

        let teacher = User(
            id: UUID(),
            name: "Daniel",
            email: "daniel@email.com",
            role: .teacher
        )

        // Create shared repositories
        let lessonRepository = LocalLessonRepository()
        let practiceTaskRepository = LocalPracticeTaskRepository()

        // Sample lesson using the SAME user IDs
        let sampleLesson = Lesson(
            id: UUID(),
            title: "Piano Lesson",
            date: Date().addingTimeInterval(86400),
            studentID: student.id,
            teacherID: teacher.id,
            notes: "Practise C major scale and bars 1–16.",
            location: "Room 3"
        )

        lessonRepository.addLesson(sampleLesson)

        // Sample practice tasks
        let task1 = PracticeTask(
            id: UUID(),
            title: "Practise C Major scale",
            description: "Practise slowly with both hands.",
            studentID: student.id,
            teacherID: teacher.id,
            dueDate: Date().addingTimeInterval(86400),
            isCompleted: true
        )

        let task2 = PracticeTask(
            id: UUID(),
            title: "Complete rhythm quiz",
            description: "Complete the rhythm quiz before your next lesson.",
            studentID: student.id,
            teacherID: teacher.id,
            dueDate: Date().addingTimeInterval(172800),
            isCompleted: false
        )

        let task3 = PracticeTask(
            id: UUID(),
            title: "Practise bars 1–16",
            description: "Focus on accurate notes and rhythm.",
            studentID: student.id,
            teacherID: teacher.id,
            dueDate: Date().addingTimeInterval(259200),
            isCompleted: false
        )

        practiceTaskRepository.addTask(task1)
        practiceTaskRepository.addTask(task2)
        practiceTaskRepository.addTask(task3)

        // Assign everything to RootView properties
        self.sampleStudent = student
        self.sampleTeacher = teacher

        self.lessonRepository = lessonRepository
        self.practiceTaskRepository = practiceTaskRepository
    }

    var body: some View {

        if let user = currentUser {

            switch user.role {

            case .student:

                StudentHomeView(
                    viewModel: StudentHomeViewModel(
                        lessonRepository: lessonRepository,
                        practiceTaskRepository: practiceTaskRepository
                    ),
                    lessonRepository: lessonRepository,
                    studentID: user.id
                )
            case .teacher:

                Text("Teacher Home")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }

        } else {

            LoginView(
                sampleStudent: sampleStudent,
                sampleTeacher: sampleTeacher
            ) { user in
                currentUser = user
            }
        }
    }
}

#Preview {
    RootView()
}
