//
//  LessonDetailView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 6/9/2026.
//

import SwiftUI

struct LessonDetailView: View {

    let lesson: Lesson

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                Text(lesson.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 6) {

                    Text(lesson.date, style: .date)

                    Text(lesson.date, style: .time)

                    Text(lesson.location)
                }
                .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: 8) {

                    Text("Lesson Notes")
                        .font(.headline)

                    Text(lesson.notes)
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {

                    Text("Practice Tasks")
                        .font(.headline)

                    Text("Practice tasks will appear here.")
                        .foregroundStyle(.secondary)
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {

                    Text("Resources")
                        .font(.headline)

                    Text("Lesson resources will appear here.")
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Lesson Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {

    LessonDetailView(
        lesson: Lesson(
            id: UUID(),
            title: "Piano Lesson",
            date: Date(),
            studentID: UUID(),
            teacherID: UUID(),
            notes: "Practise C major scale and bars 1–16.",
            location: "Room 3"
        )
    )
}
