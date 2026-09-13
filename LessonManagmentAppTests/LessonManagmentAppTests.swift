//
//  LessonManagmentAppTests.swift
//  LessonManagmentAppTests
//
//  Created by Eden Fernando on 13/9/2026.
//

import Testing
import SwiftData
import Foundation

@testable import LessonManagmentApp

@MainActor
struct LessonManagmentAppTests {

    // MARK: - Helper

    private func makeContainer() throws -> ModelContainer {

        let configuration =
            ModelConfiguration(
                isStoredInMemoryOnly: true
            )

        return try ModelContainer(
            for:
                User.self,
                Lesson.self,
                PracticeTask.self,
                Resource.self,
            configurations:
                configuration
        )
    }


    // MARK: - 1. Lesson Scheduling - Happy Path

    @Test
    func scheduleLesson_succeeds_whenTimeDoesNotOverlapExistingLesson() throws {

        let container = try makeContainer()

        let lessonRepository =
            LocalLessonRepository(
                modelContext: container.mainContext
            )

        let userRepository =
            LocalUserRepository(
                modelContext: container.mainContext
            )

        let practiceTaskRepository =
            LocalPracticeTaskRepository(
                modelContext: container.mainContext
            )

        let resourceRepository =
            LocalResourceRepository(
                modelContext: container.mainContext
            )

        let teacherID = UUID()
        let studentID = UUID()

        let existingStart = Date()

        let existingLesson = Lesson(
            id: UUID(),
            title: "Piano Lesson",
            date: existingStart,
            durationMinutes: 60,
            studentID: studentID,
            teacherID: teacherID,
            notes: "",
            location: "Room 1"
        )

        lessonRepository.addLesson(
            existingLesson
        )

        let viewModel =
            TeacherCalendarViewModel(
                lessonRepository: lessonRepository,
                userRepository: userRepository,
                practiceTaskRepository:
                    practiceTaskRepository,
                resourceRepository:
                    resourceRepository
            )

        viewModel.loadData(
            teacherID: teacherID
        )

        let newLessonStart =
            existingStart.addingTimeInterval(
                2 * 60 * 60
            )

        let conflict =
            viewModel.conflictingLesson(
                startingDate: newLessonStart,
                durationMinutes: 60,
                teacherID: teacherID,
                repeatOption: .none,
                numberOfLessons: 1
            )

        #expect(conflict == nil)
    }


    // MARK: - 2. Lesson Scheduling - Overlap Error

    @Test
    func scheduleLesson_detectsConflict_whenTimesOverlap() throws {

        let container = try makeContainer()

        let lessonRepository =
            LocalLessonRepository(
                modelContext: container.mainContext
            )

        let viewModel =
            TeacherCalendarViewModel(
                lessonRepository: lessonRepository,
                userRepository:
                    LocalUserRepository(
                        modelContext: container.mainContext
                    ),
                practiceTaskRepository:
                    LocalPracticeTaskRepository(
                        modelContext: container.mainContext
                    ),
                resourceRepository:
                    LocalResourceRepository(
                        modelContext: container.mainContext
                    )
            )

        let teacherID = UUID()
        let studentID = UUID()

        let existingStart = Date()

        let existingLesson = Lesson(
            id: UUID(),
            title: "Piano Lesson",
            date: existingStart,
            durationMinutes: 60,
            studentID: studentID,
            teacherID: teacherID,
            notes: "",
            location: "Room 1"
        )

        lessonRepository.addLesson(
            existingLesson
        )

        viewModel.loadData(
            teacherID: teacherID
        )

        // Starts 30 minutes into an existing 60-minute lesson.
        let overlappingStart =
            existingStart.addingTimeInterval(
                30 * 60
            )

        let conflict =
            viewModel.conflictingLesson(
                startingDate: overlappingStart,
                durationMinutes: 60,
                teacherID: teacherID,
                repeatOption: .none,
                numberOfLessons: 1
            )

        #expect(conflict != nil)
    }


    // MARK: - 3. Lesson Scheduling - Boundary

    @Test
    func scheduleLesson_succeeds_whenStartingExactlyWhenPreviousLessonEnds() throws {

        let container = try makeContainer()

        let lessonRepository =
            LocalLessonRepository(
                modelContext: container.mainContext
            )

        let viewModel =
            TeacherCalendarViewModel(
                lessonRepository: lessonRepository,
                userRepository:
                    LocalUserRepository(
                        modelContext: container.mainContext
                    ),
                practiceTaskRepository:
                    LocalPracticeTaskRepository(
                        modelContext: container.mainContext
                    ),
                resourceRepository:
                    LocalResourceRepository(
                        modelContext: container.mainContext
                    )
            )

        let teacherID = UUID()
        let studentID = UUID()

        let existingStart = Date()

        let existingLesson = Lesson(
            id: UUID(),
            title: "Piano Lesson",
            date: existingStart,
            durationMinutes: 60,
            studentID: studentID,
            teacherID: teacherID,
            notes: "",
            location: "Room 1"
        )

        lessonRepository.addLesson(
            existingLesson
        )

        viewModel.loadData(
            teacherID: teacherID
        )

        let exactEndTime =
            existingStart.addingTimeInterval(
                60 * 60
            )

        let conflict =
            viewModel.conflictingLesson(
                startingDate: exactEndTime,
                durationMinutes: 60,
                teacherID: teacherID,
                repeatOption: .none,
                numberOfLessons: 1
            )

        #expect(conflict == nil)
    }


    // MARK: - 4. Practice Task - Happy Path

    @Test
    func assignPracticeTask_succeeds_whenDueDateIsAfterLesson() throws {

        let container = try makeContainer()

        let lessonRepository =
            LocalLessonRepository(
                modelContext: container.mainContext
            )

        let practiceTaskRepository =
            LocalPracticeTaskRepository(
                modelContext: container.mainContext
            )

        let teacherID = UUID()
        let studentID = UUID()
        let lessonID = UUID()

        let lessonDate = Date()

        let lesson = Lesson(
            id: lessonID,
            title: "Piano Lesson",
            date: lessonDate,
            durationMinutes: 60,
            studentID: studentID,
            teacherID: teacherID,
            notes: "",
            location: "Room 1"
        )

        lessonRepository.addLesson(
            lesson
        )

        let viewModel =
            TeacherPracticeViewModel(
                practiceTaskRepository:
                    practiceTaskRepository,
                userRepository:
                    LocalUserRepository(
                        modelContext: container.mainContext
                    ),
                lessonRepository:
                    lessonRepository
            )

        viewModel.loadData(
            teacherID: teacherID
        )

        let dueDate =
            lessonDate.addingTimeInterval(
                24 * 60 * 60
            )

        let result =
            viewModel.assignTask(
                title: "Practise Scale",
                description:
                    "Practise the C major scale.",
                studentID: studentID,
                teacherID: teacherID,
                lessonID: lessonID,
                dueDate: dueDate
            )

        #expect(result == true)
        #expect(viewModel.tasks.count == 1)
    }


    // MARK: - 5. Practice Task - Due Before Lesson

    @Test
    func assignPracticeTask_fails_whenDueDateIsBeforeLesson() throws {

        let container = try makeContainer()

        let lessonRepository =
            LocalLessonRepository(
                modelContext: container.mainContext
            )

        let teacherID = UUID()
        let studentID = UUID()
        let lessonID = UUID()

        let lessonDate = Date()

        lessonRepository.addLesson(
            Lesson(
                id: lessonID,
                title: "Piano Lesson",
                date: lessonDate,
                durationMinutes: 60,
                studentID: studentID,
                teacherID: teacherID,
                notes: "",
                location: "Room 1"
            )
        )

        let viewModel =
            TeacherPracticeViewModel(
                practiceTaskRepository:
                    LocalPracticeTaskRepository(
                        modelContext: container.mainContext
                    ),
                userRepository:
                    LocalUserRepository(
                        modelContext: container.mainContext
                    ),
                lessonRepository:
                    lessonRepository
            )

        viewModel.loadData(
            teacherID: teacherID
        )

        let dueDate =
            lessonDate.addingTimeInterval(
                -60 * 60
            )

        let result =
            viewModel.assignTask(
                title: "Practise Scale",
                description: "",
                studentID: studentID,
                teacherID: teacherID,
                lessonID: lessonID,
                dueDate: dueDate
            )

        #expect(result == false)
        #expect(viewModel.tasks.isEmpty)
    }


    // MARK: - 6. Practice Task - Boundary

    @Test
    func assignPracticeTask_fails_whenDueDateEqualsLessonTime() throws {

        let container = try makeContainer()

        let lessonRepository =
            LocalLessonRepository(
                modelContext: container.mainContext
            )

        let teacherID = UUID()
        let studentID = UUID()
        let lessonID = UUID()

        let lessonDate = Date()

        lessonRepository.addLesson(
            Lesson(
                id: lessonID,
                title: "Piano Lesson",
                date: lessonDate,
                durationMinutes: 60,
                studentID: studentID,
                teacherID: teacherID,
                notes: "",
                location: "Room 1"
            )
        )

        let viewModel =
            TeacherPracticeViewModel(
                practiceTaskRepository:
                    LocalPracticeTaskRepository(
                        modelContext: container.mainContext
                    ),
                userRepository:
                    LocalUserRepository(
                        modelContext: container.mainContext
                    ),
                lessonRepository:
                    lessonRepository
            )

        viewModel.loadData(
            teacherID: teacherID
        )

        let result =
            viewModel.assignTask(
                title: "Practise Scale",
                description: "",
                studentID: studentID,
                teacherID: teacherID,
                lessonID: lessonID,
                dueDate: lessonDate
            )

        #expect(result == false)
        #expect(viewModel.tasks.isEmpty)
    }


    // MARK: - 7. Login - Happy Path

    @Test
    func login_succeeds_withCorrectEmailAndPassword() throws {

        let container = try makeContainer()

        let userRepository =
            LocalUserRepository(
                modelContext: container.mainContext
            )

        let user = User(
            id: UUID(),
            name: "Mia",
            email: "mia@email.com",
            password: "student123",
            role: .student
        )

        userRepository.addUser(
            user
        )

        let viewModel =
            LoginViewModel(
                userRepository: userRepository
            )

        viewModel.email =
            "mia@email.com"

        viewModel.password =
            "student123"

        let loggedInUser =
            viewModel.login()

        #expect(loggedInUser != nil)
        #expect(loggedInUser?.email == "mia@email.com")
        #expect(viewModel.errorMessage.isEmpty)
    }


    // MARK: - 8. Login - Incorrect Password

    @Test
    func login_fails_withIncorrectPassword() throws {

        let container = try makeContainer()

        let userRepository =
            LocalUserRepository(
                modelContext: container.mainContext
            )

        let user = User(
            id: UUID(),
            name: "Mia",
            email: "mia@email.com",
            password: "student123",
            role: .student
        )

        userRepository.addUser(
            user
        )

        let viewModel =
            LoginViewModel(
                userRepository: userRepository
            )

        viewModel.email =
            "mia@email.com"

        viewModel.password =
            "wrongpassword"

        let loggedInUser =
            viewModel.login()

        #expect(loggedInUser == nil)

        #expect(
            viewModel.errorMessage ==
            "Email or password is incorrect. Please check your details and try again."
        )
    }
}
