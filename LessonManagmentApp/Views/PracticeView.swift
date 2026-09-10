//
//  PracticeView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 6/9/2026.
//

import SwiftUI

struct PracticeView: View {

    @StateObject var viewModel: PracticeViewModel
    let studentID: UUID

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 20) {

                    Text("Practice")
                        .font(.largeTitle)
                        .fontWeight(.bold)

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

                    Text("Your Tasks")
                        .font(.headline)

                    ForEach(viewModel.practiceTasks) { task in

                        Button {
                            viewModel.toggleTaskCompletion(task)
                        } label: {

                            HStack(alignment: .top, spacing: 12) {

                                Image(
                                    systemName:
                                        task.isCompleted
                                        ? "checkmark.circle.fill"
                                        : "circle"
                                )

                                VStack(alignment: .leading, spacing: 4) {

                                    Text(task.title)
                                        .fontWeight(.semibold)

                                    Text(task.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)

                                    if let dueDate = task.dueDate {

                                        Text("Due \(dueDate, style: .date)")
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
                            .background(.gray.opacity(0.15))
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadTasks(for: studentID)
        }
    }
}

#Preview {

    let studentID = UUID()
    let teacherID = UUID()

    let practiceTaskRepository = LocalPracticeTaskRepository()

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
        studentID: studentID
    )
}
