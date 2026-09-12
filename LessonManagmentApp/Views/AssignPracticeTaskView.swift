//
//  AssignPracticeTaskView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import SwiftUI

struct AssignPracticeTaskView: View {

    let teacher: User
    
    @ObservedObject var viewModel: TeacherPracticeViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var selectedStudentID: UUID?
    @State private var selectedLessonID: UUID?
    
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()

    var body: some View {

        NavigationStack {

            Form {

                // MARK: - Student

                Section("Student") {

                    Picker(
                        "Select Student",
                        selection: $selectedStudentID
                    ) {

                        Text("Select a student")
                            .tag(UUID?.none)

                        ForEach(viewModel.students) { student in

                            Text(student.name)
                                .tag(
                                    Optional(student.id)
                                )
                        }
                    }
                }
                .onChange(
                    of: selectedStudentID
                ) {
                    selectedLessonID = nil
                }
                
                Section("Lesson") {

                    if let selectedStudentID {

                        let studentLessons =
                            viewModel.lessonsForStudent(
                                studentID: selectedStudentID
                            )

                        if studentLessons.isEmpty {

                            Text(
                                "This student has no lessons available."
                            )
                            .foregroundStyle(.secondary)

                        } else {

                            Picker(
                                "Select Lesson",
                                selection: $selectedLessonID
                            ) {

                                Text("Select a lesson")
                                    .tag(UUID?.none)

                                ForEach(
                                    studentLessons,
                                    id: \.id
                                ) { lesson in

                                    Text(
                                        "\(lesson.title) - \(lesson.date.formatted(date: .abbreviated, time: .shortened))"
                                    )
                                    .tag(
                                        Optional(
                                            lesson.id
                                        )
                                    )
                                }
                            }
                        }

                    } else {

                        Text(
                            "Select a student first."
                        )
                        .foregroundStyle(.secondary)
                    }
                }

                // MARK: - Task Details

                Section("Task Details") {

                    TextField(
                        "Task title",
                        text: $title
                    )

                    TextField(
                        "Description",
                        text: $description,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                }

                // MARK: - Due Date

                Section("Due Date") {

                    DatePicker(
                        "Due Date",
                        selection: $dueDate,
                        displayedComponents: .date
                    )
                }

                // MARK: - Assign

                Section {

                    Button {

                        assignTask()

                    } label: {

                        Text("Assign Task")
                            .fontWeight(.semibold)
                            .frame(
                                maxWidth: .infinity
                            )
                    }
                    .disabled(
                        selectedStudentID == nil
                        ||
                        selectedLessonID == nil
                        ||
                        title
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                    )
                }
            }
            .navigationTitle(
                "Assign Practice Task"
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement: .topBarLeading
                ) {

                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Assign Task

    private func assignTask() {

        guard
            let selectedStudentID,
            let selectedLessonID
        else {
            return
        }

        viewModel.assignTask(
            title: title,
            description: description,
            studentID: selectedStudentID,
            teacherID: teacher.id,
            lessonID: selectedLessonID,
            dueDate: dueDate
        )

        dismiss()
    }
}
