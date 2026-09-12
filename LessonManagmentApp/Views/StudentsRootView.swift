//
//  StudentsRootView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 10/9/2026.
//

import SwiftUI

struct StudentRootView: View {

    @State private var selectedSection: StudentSection = .home
    @State private var showMenu = false

    let student: User
    let lessonRepository: LessonRepository
    let practiceTaskRepository: PracticeTaskRepository
    let resourceRepository: ResourceRepository

    let onLogout: () -> Void

    var body: some View {

        ZStack {

            // Current page

            currentPage

            // Shared side menu

            if showMenu {

                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showMenu = false
                    }

                HStack(spacing: 0) {

                    Spacer()

                    VStack(alignment: .leading, spacing: 0) {

                        HStack {

                            Text("Menu")
                                .font(.title2)
                                .fontWeight(.bold)

                            Spacer()

                            Button {
                                showMenu = false
                            } label: {

                                Image(systemName: "xmark")
                                    .font(.title2)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 60)
                        .padding(.bottom, 25)

                        Divider()

                        menuButton(
                            title: "Home",
                            icon: "house",
                            section: .home
                        )

                        menuButton(
                            title: "Calendar",
                            icon: "calendar",
                            section: .calendar
                        )

                        menuButton(
                            title: "Practice",
                            icon: "music.note",
                            section: .practice
                        )

                        menuButton(
                            title: "Resources",
                            icon: "folder",
                            section: .resources
                        )

                        menuButton(
                            title: "Quizzes",
                            icon: "questionmark.circle",
                            section: .quizzes
                        )

                    

                        menuButton(
                            title: "Settings",
                            icon: "gearshape",
                            section: .settings
                        )

                        Spacer()
                    }
                    .frame(width: 300)
                    .background(Color(.systemBackground))
                    .ignoresSafeArea()
                    .shadow(radius: 10)
                }
            }
        }
    }

    // MARK: - Current Page

    @ViewBuilder
    private var currentPage: some View {

        switch selectedSection {

        case .home:

            StudentHomeView(
                viewModel: StudentHomeViewModel(
                    lessonRepository: lessonRepository,
                    practiceTaskRepository: practiceTaskRepository
                ),
                studentID: student.id,
                showMenu: $showMenu,
                selectedSection: $selectedSection
            )

        case .calendar:

            CalendarView(
                viewModel: CalendarViewModel(
                    lessonRepository: lessonRepository
                ),
                showMenu: $showMenu,
                studentID: student.id
            )

        case .practice:

            PracticeView(
                viewModel: PracticeViewModel(
                    practiceTaskRepository: practiceTaskRepository
                ),
                showMenu: $showMenu,
                studentID: student.id
            )

        case .resources:

            ResourcesView(
                showMenu: $showMenu,
                viewModel:
                    StudentResourcesViewModel(
                        resourceRepository:
                            resourceRepository
                    ),
                studentID: student.id
            )

        case .quizzes:

            QuizzesView(
                showMenu: $showMenu,
                viewModel: QuizViewModel(
                    quizRepository: LocalQuizRepository()
                )
            )
            
        

        case .settings:

            SettingsView(
                showMenu: $showMenu,
                studentName: student.name,
                studentEmail: student.email,
                onLogout: onLogout
            )
        }
    }

    // MARK: - Menu Button

    private func menuButton(
        title: String,
        icon: String,
        section: StudentSection
    ) -> some View {

        Button {

            selectedSection = section
            showMenu = false

        } label: {

            HStack(spacing: 18) {

                Image(systemName: icon)
                    .frame(width: 28)

                Text(title)
                    .font(.title3)

                Spacer()
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
