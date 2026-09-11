//
//  StudentHomeView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 30/8/2026.
//

import SwiftUI

import SwiftUI
import Lottie

struct StudentHomeView: View {

    @StateObject var viewModel: StudentHomeViewModel

    let lessonRepository: LessonRepository
    let practiceTaskRepository: PracticeTaskRepository
    let studentID: UUID

    @Binding var showMenu: Bool
    @Binding var selectedSection: StudentSection

    @State private var animatingTaskID: UUID?
    
    var body: some View {

        ZStack {

            ScrollView {

                VStack(
                    alignment: .leading,
                    spacing: 20
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
                    
                    Text("Welcome!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // MARK: - Upcoming Lesson
                    
                    if let lesson = viewModel.upcomingLesson {
                        
                        VStack(
                            alignment: .leading,
                            spacing: 8
                        ) {
                            
                            Text("Upcoming Lesson")
                                .font(.headline)
                            
                            Text(lesson.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
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
                                    
                                    HStack(spacing: 5) {
                                        
                                        Text("View Calendar")
                                        
                                        Image(
                                            systemName:
                                                "chevron.right"
                                        )
                                    }
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.blue)
                                }
                            }
                            .padding(.top, 4)
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
                        
                    } else {
                        
                        Text("No upcoming lessons")
                            .foregroundStyle(.secondary)
                    }
                    
                    // MARK: - Weekly Progress
                    
                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {
                        
                        Text("This Week's Progress")
                            .font(.headline)
                        
                        ProgressView(
                            value: viewModel.progress
                        )
                        
                        Text(
                            "\(Int(viewModel.progress * 100))% complete"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    
                    Divider()
                    
                    // MARK: - Tasks
                    
                    Text("Tasks")
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
                            
                            HStack(
                                alignment: .top,
                                spacing: 12
                            ) {
                                
                                // MARK: - Checkbox / Completion Animation
                                
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
            }
                .padding()
            }

            // MARK: - Completion Animation

            
        .onAppear {

            viewModel.loadHomeData(
                for: studentID
            )
        }
    }
}

#Preview {

    @Previewable
    @State var showMenu = false

    @Previewable
    @State var selectedSection:
        StudentSection = .home

    let studentID = UUID()
    let teacherID = UUID()

    let lessonRepository =
        LocalLessonRepository()

    let practiceTaskRepository =
        LocalPracticeTaskRepository()

    let sampleLesson = Lesson(
        id: UUID(),
        title: "Piano Lesson",
        date:
            Date()
                .addingTimeInterval(86400),
        studentID: studentID,
        teacherID: teacherID,
        notes:
            "Practise C major scale and bars 1–16.",
        location: "Room 3"
    )

    lessonRepository.addLesson(
        sampleLesson
    )

    let task1 = PracticeTask(
        id: UUID(),
        title:
            "Practise C Major scale",
        description:
            "Practise slowly with both hands.",
        studentID: studentID,
        teacherID: teacherID,
        dueDate:
            Date()
                .addingTimeInterval(86400),
        isCompleted: true
    )

    let task2 = PracticeTask(
        id: UUID(),
        title:
            "Complete rhythm quiz",
        description:
            "Complete the rhythm quiz before your next lesson.",
        studentID: studentID,
        teacherID: teacherID,
        dueDate:
            Date()
                .addingTimeInterval(172800),
        isCompleted: false
    )

    let task3 = PracticeTask(
        id: UUID(),
        title:
            "Practise bars 1–16",
        description:
            "Focus on accurate notes and rhythm.",
        studentID: studentID,
        teacherID: teacherID,
        dueDate:
            Date()
                .addingTimeInterval(259200),
        isCompleted: false
    )

    practiceTaskRepository.addTask(
        task1
    )

    practiceTaskRepository.addTask(
        task2
    )

    practiceTaskRepository.addTask(
        task3
    )

    let viewModel =
        StudentHomeViewModel(
            lessonRepository:
                lessonRepository,
            practiceTaskRepository:
                practiceTaskRepository
        )

    return StudentHomeView(
        viewModel: viewModel,
        lessonRepository:
            lessonRepository,
        practiceTaskRepository:
            practiceTaskRepository,
        studentID: studentID,
        showMenu: $showMenu,
        selectedSection:
            $selectedSection
    )
}
