//
//  AddLessonView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import SwiftUI

struct AddLessonView: View {

    let teacher: User
    
    @ObservedObject var viewModel: TeacherCalendarViewModel

    @Environment(\.dismiss)
    private var dismiss

    @State private var selectedStudentID: UUID?

    @State private var title = "Piano Lesson"

    @State private var date = Date()

    @State private var location = ""

    @State private var notes = ""

    @State private var repeatOption:
        LessonRepeatOption = .none

    @State private var numberOfLessons = 4

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
                                    Optional(
                                        student.id
                                    )
                                )
                        }
                    }
                }

                // MARK: - Lesson Details

                Section("Lesson Details") {

                    TextField(
                        "Lesson title",
                        text: $title
                    )

                    DatePicker(
                        "Date and Time",
                        selection: $date,
                        displayedComponents: [
                            .date,
                            .hourAndMinute
                        ]
                    )

                    TextField(
                        "Location",
                        text: $location
                    )
                }

                // MARK: - Repeat

                Section("Repeat") {

                    Picker(
                        "Repeat",
                        selection: $repeatOption
                    ) {

                        ForEach(
                            LessonRepeatOption.allCases
                        ) { option in

                            Text(
                                option.displayName
                            )
                            .tag(option)
                        }
                    }

                    if repeatOption != .none {

                        Stepper(
                            "Number of lessons: \(numberOfLessons)",
                            value: $numberOfLessons,
                            in: 2...20
                        )
                    }
                }

                // MARK: - Notes

                Section("Notes") {

                    TextField(
                        "Lesson notes",
                        text: $notes,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                }

                // MARK: - Add Lesson

                Section {

                    Button {

                        addLesson()

                    } label: {

                        Text(
                            repeatOption == .none
                            ? "Add Lesson"
                            : "Add Lessons"
                        )
                        .fontWeight(.semibold)
                        .frame(
                            maxWidth: .infinity
                        )
                    }
                    .disabled(
                        selectedStudentID == nil
                        ||
                        title
                            .trimmingCharacters(
                                in:
                                    .whitespacesAndNewlines
                            )
                            .isEmpty
                        ||
                        location
                            .trimmingCharacters(
                                in:
                                    .whitespacesAndNewlines
                            )
                            .isEmpty
                    )
                }
            }
            .navigationTitle(
                "Add Lesson"
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

    // MARK: - Add Lesson

    private func addLesson() {

        guard let selectedStudentID
        else {
            return
        }

        viewModel.addLesson(
            title: title,
            date: date,
            location: location,
            notes: notes,
            studentID: selectedStudentID,
            teacherID: teacher.id,
            repeatOption: repeatOption,
            numberOfLessons: numberOfLessons
        )

        dismiss()
    }

    // MARK: - Calculate Repeated Date

    private func dateForLesson(
        index: Int
    ) -> Date {

        let calendar =
            Calendar.current

        switch repeatOption {

        case .none:

            return date

        case .weekly:

            return calendar.date(
                byAdding: .weekOfYear,
                value: index,
                to: date
            ) ?? date

        case .fortnightly:

            return calendar.date(
                byAdding: .weekOfYear,
                value: index * 2,
                to: date
            ) ?? date
        }
    }
}
