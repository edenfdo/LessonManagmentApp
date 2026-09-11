//
//  QuizzesView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 10/9/2026.
//

import SwiftUI

struct QuizzesView: View {

    @Binding var showMenu: Bool

    @State private var showTrebleQuiz = false
    @State private var showBassQuiz = false

    // MARK: - Sample Treble Clef Question

    private let trebleQuestions: [QuizQuestion] = [

        QuizQuestion(
            id: UUID(),
            imageName: "treble-note-c",
            answers: ["C", "D", "E", "F"],
            correctAnswer: "C"
        ),

        QuizQuestion(
            id: UUID(),
            imageName: "treble-note-d",
            answers: ["C", "D", "E", "F"],
            correctAnswer: "D"
        ),

        QuizQuestion(
            id: UUID(),
            imageName: "treble-note-e",
            answers: ["D", "E", "F", "G"],
            correctAnswer: "E"
        ),

        QuizQuestion(
            id: UUID(),
            imageName: "treble-note-f",
            answers: ["E", "F", "G", "A"],
            correctAnswer: "F"
        ),

        QuizQuestion(
            id: UUID(),
            imageName: "treble-note-g",
            answers: ["F", "G", "A", "B"],
            correctAnswer: "G"
        ),

        QuizQuestion(
            id: UUID(),
            imageName: "treble-note-a",
            answers: ["G", "A", "B", "C"],
            correctAnswer: "A"
        ),

        QuizQuestion(
            id: UUID(),
            imageName: "treble-note-b",
            answers: ["A", "B", "C", "D"],
            correctAnswer: "B"
        )
    ]
    
    // MARK: - Bass Clef Questions

    private let bassQuestions: [QuizQuestion] = [

        QuizQuestion(
            id: UUID(),
            imageName: "bass-note-c",
            answers: ["C", "D", "E", "F"],
            correctAnswer: "C"
        ),

        QuizQuestion(
            id: UUID(),
            imageName: "bass-note-d",
            answers: ["C", "D", "E", "F"],
            correctAnswer: "D"
        ),

        QuizQuestion(
            id: UUID(),
            imageName: "bass-note-e",
            answers: ["D", "E", "F", "G"],
            correctAnswer: "E"
        ),

        QuizQuestion(
            id: UUID(),
            imageName: "bass-note-f",
            answers: ["E", "F", "G", "A"],
            correctAnswer: "F"
        ),

        QuizQuestion(
            id: UUID(),
            imageName: "bass-note-g",
            answers: ["F", "G", "A", "B"],
            correctAnswer: "G"
        ),

        QuizQuestion(
            id: UUID(),
            imageName: "bass-note-a",
            answers: ["G", "A", "B", "C"],
            correctAnswer: "A"
        ),

        QuizQuestion(
            id: UUID(),
            imageName: "bass-note-b",
            answers: ["A", "B", "C", "D"],
            correctAnswer: "B"
        )
    ]
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

                Text("Quizzes")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(
                    "Practise your note reading skills with these short quizzes."
                )
                .foregroundStyle(.secondary)

                // MARK: - Treble Clef Quiz

                Button {

                    showTrebleQuiz = true

                } label: {

                    quizCardContent(
                        title: "Treble Clef Note Reading",
                        description:
                            "Practise identifying notes written in the treble clef.",
                        time: "5 min",
                        icon: "music.note"
                    )
                }
                .buttonStyle(.plain)

                // MARK: - Bass Clef Quiz

                Button {

                    showBassQuiz = true

                } label: {

                    quizCardContent(
                        title: "Bass Clef Note Reading",
                        description:
                            "Practise identifying notes written in the bass clef.",
                        time: "5 min",
                        icon: "music.note"
                    )
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding()
        }

        // MARK: - Open Treble Clef Quiz

        .fullScreenCover(
            isPresented: $showTrebleQuiz
        ) {

            QuizPlayerView(
                title: "Treble Clef Note Reading",
                questions: trebleQuestions,
                isShowingQuiz: $showTrebleQuiz
            )
        }
        .fullScreenCover(
            isPresented: $showBassQuiz
        ) {

            QuizPlayerView(
                title: "Bass Clef Note Reading",
                questions: bassQuestions,
                isShowingQuiz: $showBassQuiz
            )
        }
    }

    // MARK: - Quiz Card

    private func quizCardContent(
        title: String,
        description: String,
        time: String,
        icon: String
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            HStack(
                alignment: .top,
                spacing: 14
            ) {

                // Quiz Icon

                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .frame(
                        width: 48,
                        height: 48
                    )
                    .background(
                        .blue.opacity(0.12)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                    )

                // Quiz Information

                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {

                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            // MARK: - Bottom Information

            HStack {

                HStack(spacing: 5) {

                    Image(
                        systemName: "clock"
                    )

                    Text(time)
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                Spacer()

                HStack(spacing: 5) {

                    Text("Start Quiz")

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

#Preview {

    @Previewable
    @State var showMenu = false

    QuizzesView(
        showMenu: $showMenu
    )
}
