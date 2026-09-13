//
//  TeacherCalendarView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//


import SwiftUI

struct TeacherCalendarView: View {

    @Binding var showMenu: Bool

    let teacher: User

    @StateObject var viewModel: TeacherCalendarViewModel

    @State private var showAddLessonSheet = false
    @State private var selectedDate = Date()
    @State private var displayedMonth = Date()
    @State private var selectedLesson: Lesson?

    private let calendar = Calendar.current

    var body: some View {

        ZStack {

            ScrollView {

                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {

                    // MARK: - Header

                    MenuBarView(
                        showMenu: $showMenu
                    )

                    // MARK: - Page Title

                    Text("Calendar")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(
                        "View and manage your lessons."
                    )
                    .foregroundStyle(.secondary)

                    // MARK: - Add Lesson

                    Button {

                        showAddLessonSheet = true

                    } label: {

                        HStack {

                            Image(
                                systemName: "plus"
                            )

                            Text("Add Lesson")
                                .fontWeight(.semibold)

                            Spacer()
                        }
                        .padding()
                        .foregroundStyle(.white)
                        .background(.blue)
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)

                    // MARK: - Calendar

                    VStack(
                        spacing: 16
                    ) {

                        // MARK: Month Navigation

                        HStack {

                            Button {

                                changeMonth(by: -1)

                            } label: {

                                Image(
                                    systemName: "chevron.left"
                                )
                            }

                            Spacer()

                            Text(monthTitle)
                                .font(.title3)
                                .fontWeight(.semibold)

                            Spacer()

                            Button {

                                changeMonth(by: 1)

                            } label: {

                                Image(
                                    systemName: "chevron.right"
                                )
                            }
                        }

                        // MARK: Weekday Headings

                        HStack {

                            ForEach(
                                weekdaySymbols,
                                id: \.self
                            ) { day in

                                Text(day)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                                    .frame(
                                        maxWidth: .infinity
                                    )
                            }
                        }

                        // MARK: Calendar Grid

                        LazyVGrid(
                            columns: calendarColumns,
                            spacing: 10
                        ) {

                            ForEach(
                                calendarDays.indices,
                                id: \.self
                            ) { index in

                                if let date =
                                    calendarDays[index] {

                                    calendarDay(
                                        date
                                    )

                                } else {

                                    Color.clear
                                        .frame(
                                            height: 42
                                        )
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        .gray.opacity(0.08)
                    )
                    .cornerRadius(14)

                    // MARK: - Selected Date

                    Text(
                        selectedDate.formatted(
                            date: .complete,
                            time: .omitted
                        )
                    )
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 4)

                    // MARK: - Lessons

                    if lessonsForSelectedDate.isEmpty {

                        Text(
                            "No lessons scheduled for this day."
                        )
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 10)

                    } else {

                        ForEach(
                            lessonsForSelectedDate,
                            id: \.id
                        ) { lesson in

                            lessonCard(
                                lesson
                            )
                        }
                    }

                    Spacer()
                }
                .padding()
            }

            // MARK: - Lesson Details Popup

            if let lesson = selectedLesson {

                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedLesson = nil
                    }

                VStack(
                    spacing: 0
                ) {

                    HStack {

                        Text("Lesson Details")
                            .font(.title2)
                            .fontWeight(.bold)

                        Spacer()

                        Button {

                            selectedLesson = nil

                        } label: {

                            Image(
                                systemName: "xmark"
                            )
                            .font(.title2)
                            .foregroundStyle(.blue)
                        }
                    }
                    .padding()

                    Divider()

                    LessonDetailView(
                        lesson: lesson,
                        practiceTasks:
                            viewModel.practiceTasksForLesson(
                                lesson
                            ),
                        resources:
                            viewModel.resourcesForLesson(
                                lesson
                            )
                    )
                }
                .frame(
                    maxWidth: 500,
                    maxHeight: 700
                )
                .background(
                    Color(.systemBackground)
                )
                .cornerRadius(20)
                .shadow(radius: 20)
                .padding(30)
            }
        }

        .onAppear {

            viewModel.loadData(
                teacherID: teacher.id
            )
        }

        .sheet(
            isPresented: $showAddLessonSheet
        ) {

            AddLessonView(
                teacher: teacher,
                viewModel: viewModel
            )
        }
    }

    // MARK: - Calendar Day

    private func calendarDay(
        _ date: Date
    ) -> some View {

        let isToday =
            calendar.isDateInToday(
                date
            )

        let isSelected =
            calendar.isDate(
                date,
                inSameDayAs: selectedDate
            )

        let hasLesson =
            viewModel.lessons.contains {

                calendar.isDate(
                    $0.date,
                    inSameDayAs: date
                )
            }

        return Button {

            selectedDate = date

        } label: {

            Text(
                "\(calendar.component(.day, from: date))"
            )
            .frame(
                maxWidth: .infinity
            )
            .frame(
                height: 42
            )
            .foregroundStyle(
                isToday
                    ? .white
                    : .primary
            )
            .background {

                if isToday {

                    Circle()
                        .fill(.red)

                } else if hasLesson {

                    Circle()
                        .fill(
                            Color.blue.opacity(0.15)
                        )
                }
            }
            .overlay {

                if isSelected {

                    Circle()
                        .stroke(
                            Color.blue,
                            lineWidth: 2
                        )
                }
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Lesson Card

    private func lessonCard(
        _ lesson: Lesson
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            HStack {

                Text(lesson.title)
                    .font(.headline)

                Spacer()

                Text(
                    lesson.date,
                    style: .time
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            if let student =
                viewModel.studentForLesson(
                    lesson
                ) {

                HStack {

                    Image(
                        systemName: "person"
                    )

                    Text(student.name)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            HStack {

                Image(
                    systemName: "mappin.and.ellipse"
                )

                Text(
                    lesson.location
                )
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            HStack {

                Spacer()

                Button {

                    selectedLesson = lesson

                } label: {

                    HStack(
                        spacing: 5
                    ) {

                        Text(
                            "View Details"
                        )

                        Image(
                            systemName: "chevron.right"
                        )
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 4)
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
    }

    // MARK: - Lessons For Selected Date

    private var lessonsForSelectedDate:
        [Lesson] {

        viewModel.lessons
            .filter {

                calendar.isDate(
                    $0.date,
                    inSameDayAs: selectedDate
                )
            }
            .sorted {

                $0.date < $1.date
            }
    }

    // MARK: - Month Title

    private var monthTitle: String {

        displayedMonth.formatted(
            .dateTime
                .month(.wide)
                .year()
        )
    }

    // MARK: - Weekdays

    private var weekdaySymbols:
        [String] {

        [
            "S",
            "M",
            "T",
            "W",
            "T",
            "F",
            "S"
        ]
    }

    // MARK: - Calendar Columns

    private var calendarColumns:
        [GridItem] {

        Array(
            repeating:
                GridItem(
                    .flexible()
                ),
            count: 7
        )
    }

    // MARK: - Calendar Days

    private var calendarDays:
        [Date?] {

        guard let monthInterval =
            calendar.dateInterval(
                of: .month,
                for: displayedMonth
            )
        else {

            return []
        }

        let firstDay =
            monthInterval.start

        let weekday =
            calendar.component(
                .weekday,
                from: firstDay
            )

        let range =
            calendar.range(
                of: .day,
                in: .month,
                for: displayedMonth
            ) ?? 1..<1

        var days: [Date?] = []

        // Empty spaces before first day

        for _ in 1..<weekday {

            days.append(nil)
        }

        // Actual dates

        for day in range {

            if let date =
                calendar.date(
                    byAdding: .day,
                    value: day - 1,
                    to: firstDay
                ) {

                days.append(date)
            }
        }

        return days
    }

    // MARK: - Change Month

    private func changeMonth(
        by value: Int
    ) {

        if let newMonth =
            calendar.date(
                byAdding: .month,
                value: value,
                to: displayedMonth
            ) {

            displayedMonth = newMonth
            selectedDate = newMonth
        }
    }
}
