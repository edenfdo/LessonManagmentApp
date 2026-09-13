//
//  CalendarViewModel.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 6/9/2026.
//

import Foundation
import Combine

/// Provides lesson information for the student Calendar screen.
class CalendarViewModel: ObservableObject {

    @Published var lessons: [Lesson] = []
    @Published var selectedDate: Date = Date()
    
    @Published var practiceTasks: [PracticeTask] = []
    @Published var resources: [Resource] = []

    private let practiceTaskRepository: PracticeTaskRepository
    private let resourceRepository: ResourceRepository

    private let lessonRepository: LessonRepository

    init(
        lessonRepository: LessonRepository,
        practiceTaskRepository: PracticeTaskRepository,
        resourceRepository: ResourceRepository
    ) {
        self.lessonRepository = lessonRepository
        self.practiceTaskRepository = practiceTaskRepository
        self.resourceRepository = resourceRepository
    }

    // Loads all lessons belonging to the student
    func loadData(
        studentID: UUID
    ) {

        lessons =
            lessonRepository
                .getLessons(
                    forStudentID: studentID
                )

        practiceTasks =
            practiceTaskRepository
                .getTasks(
                    forStudentID: studentID
                )

        resources =
            resourceRepository
                .getResources(
                    forStudentID: studentID
                )
    }

    // Finds lessons that occur on a selected date
    func lessons(for date: Date) -> [Lesson] {

        lessons.filter { lesson in
            Calendar.current.isDate(
                lesson.date,
                inSameDayAs: date
            )
        }
    }
    
    func practiceTasksForLesson(
        _ lesson: Lesson
    ) -> [PracticeTask] {

        practiceTasks.filter {
            $0.lessonID == lesson.id
        }
    }

    func resourcesForLesson(
        _ lesson: Lesson
    ) -> [Resource] {

        resources.filter {
            $0.lessonID == lesson.id
        }
    }
    
    func toggleTaskCompletion(
        _ task: PracticeTask
    ) {

        task.isCompleted.toggle()

        practiceTaskRepository.updateTask(
            task
        )
    }
}
