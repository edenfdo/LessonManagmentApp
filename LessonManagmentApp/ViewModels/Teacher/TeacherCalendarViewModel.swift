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

    @Published var practiceTasks: [PracticeTask] = []
    @Published var resources: [Resource] = []
    
    @Published var lessons: [Lesson] = []
    @Published var students: [User] = []

    private let lessonRepository: LessonRepository
    private let userRepository: UserRepository
    
    private let practiceTaskRepository: PracticeTaskRepository
    private let resourceRepository: ResourceRepository

    init(
        lessonRepository: LessonRepository,
        userRepository: UserRepository,
        practiceTaskRepository: PracticeTaskRepository,
        resourceRepository: ResourceRepository
    ) {

        self.lessonRepository = lessonRepository
        self.userRepository = userRepository
        self.practiceTaskRepository =
            practiceTaskRepository
        self.resourceRepository =
            resourceRepository
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
        
        practiceTasks =
            practiceTaskRepository
                .getAllTasks()
                .filter {
                    $0.teacherID == teacherID
                }

        resources =
            resourceRepository
                .getResources(
                    forTeacherID: teacherID
                )
    }

    // MARK: - Add Lesson

    func addLesson(
        title: String,
        date: Date,
        durationMinutes: Int,
        location: String,
        notes: String,
        studentID: UUID,
        teacherID: UUID,
        repeatOption: LessonRepeatOption,
        numberOfLessons: Int
    ){

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
                durationMinutes: durationMinutes,
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
    
    // MARK: - Practice Tasks For Lesson

    func practiceTasksForLesson(
        _ lesson: Lesson
    ) -> [PracticeTask] {

        practiceTasks.filter {
            $0.lessonID == lesson.id
        }
    }

    // MARK: - Resources For Lesson

    func resourcesForLesson(
        _ lesson: Lesson
    ) -> [Resource] {

        resources.filter {
            $0.lessonID == lesson.id
        }
    }
    
    // MARK: - Check Lesson Conflict

    func conflictingLesson(
        startingDate: Date,
        durationMinutes: Int,
        teacherID: UUID,
        repeatOption: LessonRepeatOption,
        numberOfLessons: Int,
        excludingLessonID: UUID? = nil
    ) -> Lesson? {

        let lessonCount =
            repeatOption == .none
            ? 1
            : numberOfLessons

        for index in 0..<lessonCount {

            let newLessonStart =
                dateForLesson(
                    startingDate: startingDate,
                    index: index,
                    repeatOption: repeatOption
                )

            let newLessonEnd =
                newLessonStart.addingTimeInterval(
                    TimeInterval(
                        durationMinutes * 60
                    )
                )

            for existingLesson in lessons {

                guard
                    existingLesson.teacherID == teacherID
                else {
                    continue
                }

                if existingLesson.id ==
                    excludingLessonID {
                    continue
                }

                let existingStart =
                    existingLesson.date

                let existingEnd =
                    existingStart
                        .addingTimeInterval(
                            TimeInterval(
                                existingLesson
                                    .durationMinutes * 60
                            )
                        )

                let overlaps =
                    newLessonStart < existingEnd
                    &&
                    newLessonEnd > existingStart

                if overlaps {
                    return existingLesson
                }
            }
        }

        return nil
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
    
    func updateLesson(
        _ lesson: Lesson,
        title: String,
        date: Date,
        durationMinutes: Int,
        location: String,
        notes: String,
        teacherID: UUID
    ) {

        lesson.title = title
        lesson.date = date
        lesson.durationMinutes = durationMinutes
        lesson.location = location
        lesson.notes = notes

        lessonRepository.updateLesson(
            lesson
        )

        loadData(
            teacherID: teacherID
        )
    }
    
    func deleteLesson(
        _ lesson: Lesson,
        teacherID: UUID
    ) {

        let linkedResources =
            resources.filter {
                $0.lessonID == lesson.id
            }

        let linkedTasks =
            practiceTasks.filter {
                $0.lessonID == lesson.id
            }

        // Delete attached files + resource records
        for resource in linkedResources {

            do {

                try ResourceFileStorage.deleteFile(
                    resourceID: resource.id,
                    fileName: resource.fileName
                )

            } catch {

                print(
                    "Failed to delete resource file: \(error)"
                )
            }

            resourceRepository.deleteResource(
                resource
            )
        }

        // Delete linked practice tasks
        for task in linkedTasks {

            practiceTaskRepository.deleteTask(
                task
            )
        }

        // Delete the lesson itself
        lessonRepository.deleteLesson(
            lesson
        )

        // Reload calendar data
        loadData(
            teacherID: teacherID
        )
    }
}

