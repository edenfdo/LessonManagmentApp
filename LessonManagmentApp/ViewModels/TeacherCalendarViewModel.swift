//
//  TeacherCalendarViewModel.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import Foundation
import Combine

enum LessonRepeatOption:
    String,
    CaseIterable,
    Identifiable {

    case none
    case weekly
    case fortnightly

    var id: String {
        rawValue
    }

    var displayName: String {

        switch self {

        case .none:
            return "Does Not Repeat"

        case .weekly:
            return "Weekly"

        case .fortnightly:
            return "Fortnightly"
        }
    }
}


final class TeacherCalendarViewModel: ObservableObject {

    @Published var lessons: [Lesson] = []
    @Published var students: [User] = []

    private let lessonRepository: LessonRepository
    private let userRepository: UserRepository

    init(
        lessonRepository: LessonRepository,
        userRepository: UserRepository
    ) {
        self.lessonRepository = lessonRepository
        self.userRepository = userRepository
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
                .filter {
                    $0.date >= Date()
                }
                .sorted {
                    $0.date < $1.date
                }
    }

    // MARK: - Add Lesson

    func addLesson(
        title: String,
        date: Date,
        location: String,
        notes: String,
        studentID: UUID,
        teacherID: UUID,
        repeatOption: LessonRepeatOption,
        numberOfLessons: Int
    ) {

        let lessonCount =
            repeatOption == .none
            ? 1
            : numberOfLessons

        for index in 0..<lessonCount {

            let lessonDate =
                dateForLesson(
                    startingDate: date,
                    index: index,
                    repeatOption: repeatOption
                )

            let lesson = Lesson(
                id: UUID(),
                title: title,
                date: lessonDate,
                studentID: studentID,
                teacherID: teacherID,
                notes: notes,
                location: location
            )

            lessonRepository.addLesson(
                lesson
            )
        }

        loadData(
            teacherID: teacherID
        )
    }

    // MARK: - Find Student

    func studentForLesson(
        _ lesson: Lesson
    ) -> User? {

        students.first {
            $0.id == lesson.studentID
        }
    }

    // MARK: - Calculate Recurring Date

    private func dateForLesson(
        startingDate: Date,
        index: Int,
        repeatOption: LessonRepeatOption
    ) -> Date {

        let calendar =
            Calendar.current

        switch repeatOption {

        case .none:

            return startingDate

        case .weekly:

            return calendar.date(
                byAdding: .weekOfYear,
                value: index,
                to: startingDate
            ) ?? startingDate

        case .fortnightly:

            return calendar.date(
                byAdding: .weekOfYear,
                value: index * 2,
                to: startingDate
            ) ?? startingDate
        }
    }
}

