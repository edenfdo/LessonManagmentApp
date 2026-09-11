//
//  PracticeView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 6/9/2026.
//

import SwiftUI
import Lottie

struct PracticeView: View {

    @StateObject var viewModel: PracticeViewModel
    @Binding var showMenu: Bool

    let studentID: UUID

    @State private var animatingTaskID: UUID?

    var body: some View {

        ZStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 20) {

                    // MARK: - Header

                    HStack {

                        Text("Logo")
                            .font(.title)
                            .fontWeight(.bold)

                        Spacer()

                        Button {
                            showMenu = true
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.title)
                        }
                    }

                    // MARK: - Page Title

                    Text("Practice")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    // MARK: - Weekly Progress

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Weekly Progress")
                            .font(.headline)

                        ProgressView(value: viewModel.progress)

                        Text(
                            "\(viewModel.completedTaskCount) of \(viewModel.practiceTasks.count) tasks complete"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }

                    Divider()

                    // MARK: - Tasks

                    Text("Your Tasks")
                        .font(.headline)

                    ForEach(viewModel.practiceTasks) { task in

                        Button {

                            let wasCompleted = task.isCompleted

                            viewModel.toggleTaskCompletion(task)

                            if !wasCompleted {

                                animatingTaskID = task.id

                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + 1.5
                                ) {
                                    animatingTaskID = nil
                                }
                            }

                        } label: {

                            HStack(alignment: .top, spacing: 12) {

                                ZStack {

                                    if animatingTaskID == task.id {

                                        LottieView(
                                            animation: .named("taskComplete")
                                        )
                                        .playing()
                                        .frame(
                                            width: 32,
                                            height: 32
                                        )

                                    } else {

                                        Image(
                                            systemName:
                                                task.isCompleted
                                                ? "checkmark.circle.fill"
                                                : "circle"
                                        )
                                        .font(.title3)
                                    }
                                }
                                .frame(
                                    width: 32,
                                    height: 32
                                )
                                VStack(
                                    alignment: .leading,
                                    spacing: 4
                                ) {

                                    Text(task.title)
                                        .fontWeight(.semibold)

                                    Text(task.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)

                                    if let dueDate = task.dueDate {

                                        Text(
                                            "Due \(dueDate, style: .date)"
                                        )
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    }
                                }

                                Spacer()
                            }
                            .padding()
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .background(
                                .gray.opacity(0.15)
                            )
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }

            // MARK: - Completion Animation
        }
        .onAppear {
            viewModel.loadTasks(for: studentID)
        }
    }
}

#Preview {

    @Previewable @State var showMenu = false

    let studentID = UUID()
    let teacherID = UUID()

    let practiceTaskRepository =
        LocalPracticeTaskRepository()

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
        dueDate: Date().addingTimeInterval(172800),
        isCompleted: false
    )

    let task3 = PracticeTask(
        id: UUID(),
        title: "Practise bars 1–16",
        description: "Focus on accurate notes and rhythm.",
        studentID: studentID,
        teacherID: teacherID,
        dueDate: Date().addingTimeInterval(259200),
        isCompleted: false
    )

    practiceTaskRepository.addTask(task1)
    practiceTaskRepository.addTask(task2)
    practiceTaskRepository.addTask(task3)

    let viewModel = PracticeViewModel(
        practiceTaskRepository: practiceTaskRepository
    )

    return PracticeView(
        viewModel: viewModel,
        showMenu: $showMenu,
        studentID: studentID
    )
}
