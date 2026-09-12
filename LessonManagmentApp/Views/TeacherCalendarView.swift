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
    
    var body: some View {
        
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
                
                // MARK: - Page Title
                
                Text("Calendar")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(
                    "View and manage your upcoming lessons."
                )
                .foregroundStyle(.secondary)
                
                // MARK: - Add Lesson
                
                Button {
                    
                    showAddLessonSheet = true
                    
                } label: {
                    
                    HStack {
                        
                        Image(systemName: "plus")
                        
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
                
                // MARK: - Upcoming Lessons
                
                Text("Upcoming Lessons")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 4)
                
                if viewModel.lessons.isEmpty {
                    
                    Text("No upcoming lessons.")
                        .foregroundStyle(.secondary)
                    
                } else {
                    
                    ForEach(
                        viewModel.lessons,
                        id: \.id
                    ) { lesson in
                        
                        lessonCard(lesson)
                    }
                }
                
                Spacer()
            }
            .padding()
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
    
    // MARK: - Lesson Card
    
    private func lessonCard(
        _ lesson: Lesson
    ) -> some View {
        
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            
            Text(lesson.title)
                .font(.headline)
            
            if let student =
                viewModel.studentForLesson(
                    lesson
                ) {
                
                Text(
                    "Student: \(student.name)"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            
            HStack {
                
                Image(systemName: "calendar")
                
                Text(
                    lesson.date,
                    style: .date
                )
            }
            .foregroundStyle(.secondary)
            
            HStack {
                
                Image(systemName: "clock")
                
                Text(
                    lesson.date,
                    style: .time
                )
            }
            .foregroundStyle(.secondary)
            
            HStack {
                
                Image(
                    systemName:
                        "mappin.and.ellipse"
                )
                
                Text(lesson.location)
            }
            .foregroundStyle(.secondary)
            
            if !viewModel.lessons.isEmpty {
                
                Text(lesson.notes)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
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
    }
    
}
