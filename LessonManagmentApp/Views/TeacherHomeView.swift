//
//  TeacherHomeView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import SwiftUI

struct TeacherHomeView: View {

    let teacher: User

    @Binding var showMenu: Bool
    @Binding var selectedSection: TeacherSection

    let lessonRepository: LessonRepository

    @State private var upcomingLessons: [Lesson] = []

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                // MARK: - Header

                HStack {

                    Text("Logo")
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()

                    Button {
                        showMenu = true
                    } label: {

                        Image(
                            systemName: "line.3.horizontal"
                        )
                        .font(.title)
                    }
                }

                // MARK: - Welcome

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text(
                        "Welcome, \(teacher.name)"
                    )
                    .font(.largeTitle)
                    .fontWeight(.bold)

                    Text(
                        "Manage your lessons, students and resources."
                    )
                    .foregroundStyle(.secondary)
                }

                // MARK: - Upcoming Lessons

                Text("Upcoming Lessons")
                    .font(.title2)
                    .fontWeight(.bold)

                if let lesson = upcomingLessons.first {

                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {

                        Text(lesson.title)
                            .font(.headline)

                        Text(
                            lesson.date,
                            style: .date
                        )
                        .foregroundStyle(.secondary)

                        Text(
                            lesson.date,
                            style: .time
                        )
                        .foregroundStyle(.secondary)

                        Text(lesson.location)
                            .foregroundStyle(.secondary)

                        HStack {

                            Spacer()

                            Button {

                                selectedSection = .calendar

                            } label: {

                                HStack(spacing: 4) {

                                    Text("View Calendar")

                                    Image(
                                        systemName: "chevron.right"
                                    )
                                    .font(.caption)
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.blue)
                            }
                        }
                    }
                    .padding()
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .background(
                        .gray.opacity(0.12)
                    )
                    .cornerRadius(14)

                } else {

                    Text(
                        "No upcoming lessons."
                    )
                    .foregroundStyle(.secondary)
                }

                // MARK: - Quick Actions

                Text("Quick Actions")
                    .font(.title2)
                    .fontWeight(.bold)

                HStack(spacing: 12) {

                    quickActionButton(
                        title: "Students",
                        icon: "person.2"
                    ) {

                        selectedSection = .students
                    }

                    quickActionButton(
                        title: "Assign Task",
                        icon: "checklist"
                    ) {

                        selectedSection = .practice
                    }
                }

                HStack(spacing: 12) {

                    quickActionButton(
                        title: "Calendar",
                        icon: "calendar"
                    ) {

                        selectedSection = .calendar
                    }

                    quickActionButton(
                        title: "Resources",
                        icon: "folder"
                    ) {

                        selectedSection = .resources
                    }
                }

                // MARK: - Students

                Text("Your Students")
                    .font(.title2)
                    .fontWeight(.bold)

                Button {

                    selectedSection = .students

                } label: {

                    HStack {

                        Image(
                            systemName: "person.circle.fill"
                        )
                        .font(.largeTitle)
                        .foregroundStyle(.blue)

                        VStack(
                            alignment: .leading,
                            spacing: 4
                        ) {

                            Text("Mia")
                                .font(.headline)
                                .foregroundStyle(.primary)

                            Text(
                                "Piano Student"
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(
                            systemName: "chevron.right"
                        )
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(
                        .gray.opacity(0.12)
                    )
                    .cornerRadius(14)
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding()
        }
        .onAppear {

            loadUpcomingLessons()
        }
    }

    // MARK: - Quick Action Button

    private func quickActionButton(
        title: String,
        icon: String,
        action: @escaping () -> Void
    ) -> some View {

        Button(
            action: action
        ) {

            VStack(spacing: 10) {

                Image(systemName: icon)
                    .font(.title2)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .frame(
                maxWidth: .infinity
            )
            .padding(.vertical, 22)
            .background(
                .gray.opacity(0.12)
            )
            .cornerRadius(14)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Load Lessons

    private func loadUpcomingLessons() {

        upcomingLessons =
            lessonRepository
                .getLessons(forTeacherID: teacher.id)
                .sorted {
                    $0.date < $1.date
                }
    }
}
