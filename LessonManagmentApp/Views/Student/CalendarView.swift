//
//  CalendarView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 6/9/2026.
//

import SwiftUI
import SwiftData

struct CalendarView: View {

    @StateObject var viewModel: CalendarViewModel
    @Binding var showMenu: Bool

    let studentID: UUID

    @State private var selectedLesson: Lesson?
    @State private var displayedMonth: Date = Date()
    
    @Binding var selectedSection: StudentSection
    @Binding var resourceToOpen: Resource?

    private let calendar = Calendar.current
    private let weekdaySymbols = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {

        ZStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 20) {

                    // MARK: - Header

                    MenuBarView(
                        showMenu: $showMenu,
                        onLogoTap: {
                            selectedSection = .home
                        }
                    )

                    // MARK: - Page Title

                    Text("Calendar")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    // MARK: - Month Navigation

                    HStack {

                        Button {
                            changeMonth(by: -1)
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                        }

                        Spacer()

                        Text(monthTitle)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Spacer()

                        Button {
                            changeMonth(by: 1)
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.headline)
                        }
                    }

                    // MARK: - Weekday Headings

                    HStack {

                        ForEach(weekdaySymbols, id: \.self) { day in

                            Text(day)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }

                    // MARK: - Calendar Grid

                    let days = daysForDisplayedMonth

                    LazyVGrid(
                        columns: Array(
                            repeating: GridItem(.flexible()),
                            count: 7
                        ),
                        spacing: 12
                    ) {

                        ForEach(days.indices, id: \.self) { index in

                            if let date = days[index] {

                                Button {

                                    viewModel.selectedDate = date

                                } label: {

                                    Text(
                                        "\(calendar.component(.day, from: date))"
                                    )
                                    .fontWeight(
                                        isSelected(date)
                                        ? .semibold
                                        : .regular
                                    )
                                    .foregroundStyle(
                                        isToday(date)
                                        ? Color.white
                                        : Color.primary
                                    )
                                    .frame(
                                        width: 38,
                                        height: 38
                                    )
                                    .background(
                                        dayFill(for: date)
                                    )
                                    .clipShape(Circle())
                                    .overlay {

                                        if isSelected(date) {

                                            Circle()
                                                .stroke(
                                                    Color.primary.opacity(0.7),
                                                    lineWidth: 2
                                                )
                                        }
                                    }
                                }
                                .buttonStyle(.plain)

                            } else {

                                Color.clear
                                    .frame(
                                        width: 38,
                                        height: 38
                                    )
                            }
                        }
                    }

                    Divider()

                    // MARK: - Lessons

                    Text("Lessons")
                        .font(.headline)

                    let selectedLessons =
                        viewModel.lessons(
                            for: viewModel.selectedDate
                        )

                    if selectedLessons.isEmpty {

                        Text("No lessons scheduled for this day.")
                            .foregroundStyle(.secondary)

                    } else {

                        ForEach(selectedLessons) { lesson in

                            Button {
                                selectedLesson = lesson
                            } label: {

                                VStack(alignment: .leading, spacing: 10) {

                                    // Lesson title
                                    Text(lesson.title)
                                        .font(.headline)
                                        .foregroundStyle(.primary)

                                    // Lesson time
                                    Text(lesson.date, style: .time)
                                        .foregroundStyle(.secondary)

                                    // Lesson location
                                    Text(lesson.location)
                                        .foregroundStyle(.secondary)
                                    
                                    HStack(
                                        spacing: 20
                                    ) {

                                        HStack(
                                            spacing: 6
                                        ) {

                                            Image(
                                                systemName: "paperclip"
                                            )
                                            .foregroundStyle(.secondary)

                                            Text(
                                                "\(viewModel.resourcesForLesson(lesson).count)"
                                            )
                                            .foregroundStyle(.secondary)
                                        }

                                        HStack(
                                            spacing: 6
                                        ) {

                                            Image(
                                                systemName: "checklist"
                                            )
                                            .foregroundStyle(.secondary)

                                            Text(
                                                "\(viewModel.practiceTasksForLesson(lesson).count)"
                                            )
                                            .foregroundStyle(.secondary)
                                        }

                                        Spacer()
                                    }
                                    .font(.subheadline)
                                    
                                    // Visual cue
                                    HStack {

                                        Spacer()

                                        HStack(spacing: 5) {

                                            Text("View Details")

                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                        }
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.blue)
                                    }
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
                }
                .padding()
            }
            .onAppear {

                viewModel.loadData(
                    studentID: studentID
                )

                displayedMonth =
                    viewModel.selectedDate
            }


            // MARK: - Lesson Details Popup

            if let lesson = selectedLesson {

                Color.black.opacity(0.3)
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
                            .font(.headline)
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
                            ),
                        onToggleTask: { task in

                            viewModel.toggleTaskCompletion(
                                task
                            )
                        },
                        onOpenResource: { resource in

                            selectedLesson = nil

                            resourceToOpen =
                                resource

                            selectedSection =
                                .resources
                        }
                    )
                }
                .frame(
                    maxWidth: 320,
                    maxHeight: 700
                )
                .background(
                    Color(.systemBackground)
                )
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
            }
        }
    }

    // MARK: - Month Title

    private var monthTitle: String {

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"

        return formatter.string(
            from: displayedMonth
        )
    }

    // MARK: - Calendar Days

    private var daysForDisplayedMonth: [Date?] {

        guard let monthInterval =
                calendar.dateInterval(
                    of: .month,
                    for: displayedMonth
                )
        else {
            return []
        }

        let firstDay = monthInterval.start

        guard let numberOfDays =
                calendar.range(
                    of: .day,
                    in: .month,
                    for: firstDay
                )?.count
        else {
            return []
        }

        let weekday =
            calendar.component(
                .weekday,
                from: firstDay
            )

        let leadingEmptyDays =
            (weekday + 5) % 7

        var days: [Date?] =
            Array(
                repeating: nil,
                count: leadingEmptyDays
            )

        for day in 0..<numberOfDays {

            if let date = calendar.date(
                byAdding: .day,
                value: day,
                to: firstDay
            ) {

                days.append(date)
            }
        }

        return days
    }

    // MARK: - Date Styling

    private func hasLesson(
        on date: Date
    ) -> Bool {

        !viewModel.lessons(
            for: date
        ).isEmpty
    }

    private func isSelected(
        _ date: Date
    ) -> Bool {

        calendar.isDate(
            date,
            inSameDayAs: viewModel.selectedDate
        )
    }

    private func isToday(
        _ date: Date
    ) -> Bool {

        calendar.isDateInToday(date)
    }

    private func dayFill(for date: Date) -> Color {

        if isToday(date) {
            return Color.red
        }

        if hasLesson(on: date) {
            return Color.blue.opacity(0.18)
        }

        return Color.clear
    }

    // MARK: - Change Month

    private func changeMonth(
        by value: Int
    ) {

        if let newMonth = calendar.date(
            byAdding: .month,
            value: value,
            to: displayedMonth
        ) {

            displayedMonth = newMonth
        }
    }
}

private func makeCalendarPreviewViewModel(
    lessonRepository: LocalLessonRepository,
    practiceTaskRepository: LocalPracticeTaskRepository,
    resourceRepository: LocalResourceRepository,
    studentID: UUID,
    teacherID: UUID
) -> CalendarViewModel {

    let calendar = Calendar.current
    let today = Date()

    let lessonDate1 =
        calendar.date(
            byAdding: .day,
            value: 1,
            to: today
        )!

    let lessonDate2 =
        calendar.date(
            byAdding: .day,
            value: 3,
            to: today
        )!

    let lesson1 = Lesson(
        id: UUID(),
        title: "Piano Lesson",
        date: lessonDate1,
        durationMinutes: 60,
        studentID: studentID,
        teacherID: teacherID,
        notes: "Practise C major scale and bars 1–16.",
        location: "Room 3"
    )

    let lesson2 = Lesson(
        id: UUID(),
        title: "Piano Lesson",
        date: lessonDate2,
        durationMinutes: 60,
        studentID: studentID,
        teacherID: teacherID,
        notes: "Focus on rhythm and dynamics.",
        location: "Room 3"
    )

    lessonRepository.addLesson(lesson1)
    lessonRepository.addLesson(lesson2)

    return CalendarViewModel(
        lessonRepository: lessonRepository,
        practiceTaskRepository: practiceTaskRepository,
        resourceRepository: resourceRepository
    )
}

#Preview {

    @Previewable
    @State var showMenu = false
    
    @Previewable
    @State var selectedSection: StudentSection = .calendar

    @Previewable
    @State var resourceToOpen: Resource?

    let studentID = UUID()
    let teacherID = UUID()

    let container = try! ModelContainer(
        for: Lesson.self,
        PracticeTask.self,
        Resource.self,
        configurations: ModelConfiguration(
            isStoredInMemoryOnly: true
        )
    )

    let lessonRepository =
        LocalLessonRepository(
            modelContext: container.mainContext
        )
    
    let practiceTaskRepository =
        LocalPracticeTaskRepository(
            modelContext: container.mainContext
        )

    let resourceRepository =
        LocalResourceRepository(
            modelContext: container.mainContext
        )

    let viewModel =
        makeCalendarPreviewViewModel(
            lessonRepository: lessonRepository,
            practiceTaskRepository: practiceTaskRepository,
            resourceRepository: resourceRepository,
            studentID: studentID,
            teacherID: teacherID
        )

    CalendarView(
        viewModel: viewModel,
        showMenu: $showMenu,
        studentID: studentID,
        selectedSection: $selectedSection,
        resourceToOpen: $resourceToOpen
    )
    .modelContainer(container)
}
