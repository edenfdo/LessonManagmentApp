//
//  HomeView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import SwiftUI

struct StudentHomeView: View {

    @StateObject var viewModel: StudentHomeViewModel
    let lessonRepository: LessonRepository

    let studentID: UUID

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 20) {

                    // Header
                    HStack {

                        Text("Logo")
                            .font(.title)
                            .fontWeight(.bold)

                        Spacer()

                        Button {
                            // Open menu later
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.title)
                        }
                    }

                    // Welcome
                    Text("Welcome!")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    // Upcoming lesson
                    if let lesson = viewModel.upcomingLesson {

                        VStack(alignment: .leading, spacing: 8) {

                            Text("Upcoming Lesson")
                                .font(.headline)

                            Text(lesson.title)
                                .font(.title3)
                                .fontWeight(.semibold)

                            Text(lesson.date, style: .date)
                                .foregroundStyle(.secondary)

                            Text(lesson.date, style: .time)
                                .foregroundStyle(.secondary)

                            Text(lesson.location)
                                .foregroundStyle(.secondary)

                            // View Calendar link
                            HStack {

                                Spacer()

                                NavigationLink {

                                    CalendarView(
                                        viewModel: CalendarViewModel(
                                            lessonRepository: lessonRepository
                                        ),
                                        studentID: studentID
                                    )

                                } label: {

                                    HStack(spacing: 5) {

                                        Text("View Calendar")

                                        Image(systemName: "arrow.right")
                                    }
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.gray.opacity(0.15))
                        .cornerRadius(12)

                    } else {

                        Text("No upcoming lessons")
                            .foregroundStyle(.secondary)
                    }

                    // Weekly progress
                    VStack(alignment: .leading, spacing: 10) {

                        Text("This Week's Progress")
                            .font(.headline)

                        ProgressView(value: viewModel.progress)

                        Text("\(Int(viewModel.progress * 100))% complete")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    // Tasks
                    VStack(alignment: .leading, spacing: 10) {

                        Text("Tasks")
                            .font(.headline)

                        ForEach(viewModel.practiceTasks) { task in

                            Button {
                                viewModel.toggleTaskCompletion(task)
                            } label: {

                                HStack {

                                    Image(
                                        systemName:
                                            task.isCompleted
                                            ? "checkmark.circle.fill"
                                            : "circle"
                                    )
                                    .foregroundStyle(
                                        task.isCompleted ? .secondary : .primary
                                    )

                                    Text(task.title)

                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadHomeData(for: studentID)
        }
    }
}

#Preview {

    let studentID = UUID()
    let teacherID = UUID()

    let lessonRepository = LocalLessonRepository()
    let practiceTaskRepository = LocalPracticeTaskRepository()

    let sampleLesson = Lesson(
        id: UUID(),
        title: "Piano Lesson",
        date: Date().addingTimeInterval(86400),
        studentID: studentID,
        teacherID: teacherID,
        notes: "Practise C major scale and bars 1–16.",
        location: "Room 3"
    )

    lessonRepository.addLesson(sampleLesson)
    
    let task1 = PracticeTask(
        id: UUID(),
        title: "Practise C Major scale",
        description: "Practise slowly with both hands.",
        studentID: studentID,
        teacherID: teacherID,
        dueDate: Date().addingTimeInterval(86400),
        isCompleted: true
    )

    let task2 = PracticeTask(
        id: UUID(),
        title: "Complete rhythm quiz",
        description: "Complete the rhythm quiz before your next lesson.",
        studentID: studentID,
        teacherID: teacherID,
        dueDate: Date().addingTimeInterval(86400),
        isCompleted: false
    )

    let task3 = PracticeTask(
        id: UUID(),
        title: "Practise bars 1–16",
        description: "Focus on accurate notes and rhythm.",
        studentID: studentID,
        teacherID: teacherID,
        dueDate: Date().addingTimeInterval(86400),
        isCompleted: false
    )

    practiceTaskRepository.addTask(task1)
    practiceTaskRepository.addTask(task2)
    practiceTaskRepository.addTask(task3)

    let viewModel = StudentHomeViewModel(
        lessonRepository: lessonRepository,
        practiceTaskRepository: practiceTaskRepository
    )

    return StudentHomeView(
        viewModel: viewModel,
        lessonRepository: lessonRepository,
        studentID: studentID
    )
}
