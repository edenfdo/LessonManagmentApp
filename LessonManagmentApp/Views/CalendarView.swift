//
//  CalendarView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 6/9/2026.
//

import SwiftUI

struct CalendarView: View {

    @StateObject var viewModel: CalendarViewModel

    let studentID: UUID

    @State private var selectedLesson: Lesson?

    var body: some View {

        ZStack {

            NavigationStack {

                VStack(alignment: .leading, spacing: 20) {

                    Text("Calendar")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    DatePicker(
                        "Select Date",
                        selection: $viewModel.selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)

                    Divider()

                    Text("Lessons")
                        .font(.headline)

                    let selectedLessons =
                        viewModel.lessons(for: viewModel.selectedDate)

                    if selectedLessons.isEmpty {

                        Text("No lessons scheduled for this day.")
                            .foregroundStyle(.secondary)

                    } else {

                        ForEach(selectedLessons) { lesson in

                            Button {
                                selectedLesson = lesson
                            } label: {

                                VStack(
                                    alignment: .leading,
                                    spacing: 6
                                ) {

                                    Text(lesson.title)
                                        .font(.headline)

                                    Text(
                                        lesson.date,
                                        style: .time
                                    )
                                    .foregroundStyle(.secondary)

                                    Text(lesson.location)
                                        .foregroundStyle(.secondary)
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

                    Spacer()
                }
                .padding()
            }
            .onAppear {
                viewModel.loadLessons(for: studentID)
            }

            // Popup
            if let lesson = selectedLesson {

                Color.black.opacity(0.3)
                    .ignoresSafeArea()

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    HStack {

                        Text("Lesson Details")
                            .font(.title2)
                            .fontWeight(.bold)

                        Spacer()

                        Button {
                            selectedLesson = nil
                        } label: {
                            Image(systemName: "xmark")
                                .font(.headline)
                        }
                    }

                    Text(lesson.title)
                        .font(.headline)

                    VStack(
                        alignment: .leading,
                        spacing: 6
                    ) {

                        Text(lesson.date, style: .date)

                        Text(lesson.date, style: .time)

                        Text(lesson.location)
                    }
                    .foregroundStyle(.secondary)

                    Divider()

                    Text("Lesson Notes")
                        .font(.headline)

                    Text(lesson.notes)

                    Divider()

                    Text("Practice Tasks")
                        .font(.headline)

                    Text(
                        "Practice tasks will appear here."
                    )
                    .foregroundStyle(.secondary)

                    Divider()

                    Text("Resources")
                        .font(.headline)

                    Text(
                        "Lesson resources will appear here."
                    )
                    .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: 320)
                .background(
                    Color(.systemBackground)
                )
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
            }
        }
    }
}

#Preview {

    let studentID = UUID()
    let teacherID = UUID()

    let lessonRepository =
        LocalLessonRepository()

    let sampleLesson = Lesson(
        id: UUID(),
        title: "Piano Lesson",
        date: Date(),
        studentID: studentID,
        teacherID: teacherID,
        notes: "Practise C major scale and bars 1–16.",
        location: "Room 3"
    )

    lessonRepository.addLesson(sampleLesson)

    let viewModel = CalendarViewModel(
        lessonRepository: lessonRepository
    )

    return CalendarView(
        viewModel: viewModel,
        studentID: studentID
    )
}
