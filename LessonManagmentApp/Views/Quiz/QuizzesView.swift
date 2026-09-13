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

    @StateObject var viewModel: QuizViewModel

    var body: some View {

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

                Text("Quizzes")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(
                    "Practise your note reading skills with these short quizzes."
                )
                .foregroundStyle(.secondary)

                // MARK: - Treble Clef Quiz

                if let trebleQuiz = viewModel.trebleQuiz {

                    Button {

                        showTrebleQuiz = true

                    } label: {

                        quizCardContent(
                            title: trebleQuiz.title,
                            description: trebleQuiz.description,
                            time: trebleQuiz.estimatedTime,
                            icon: "music.note"
                        )
                    }
                    .buttonStyle(.plain)
                }

                // MARK: - Bass Clef Quiz

                if let bassQuiz = viewModel.bassQuiz {

                    Button {

                        showBassQuiz = true

                    } label: {

                        quizCardContent(
                            title: bassQuiz.title,
                            description: bassQuiz.description,
                            time: bassQuiz.estimatedTime,
                            icon: "music.note"
                        )
                    }
                    .buttonStyle(.plain)
                }

                Spacer()
            }
            .padding()
        }

        // MARK: - Open Treble Clef Quiz

        .fullScreenCover(
            isPresented: $showTrebleQuiz
        ) {

            if let trebleQuiz = viewModel.trebleQuiz {

                QuizPlayerView(
                    title: trebleQuiz.title,
                    questions: trebleQuiz.questions,
                    isShowingQuiz: $showTrebleQuiz
                )
            }
        }

        // MARK: - Open Bass Clef Quiz

        .fullScreenCover(
            isPresented: $showBassQuiz
        ) {

            if let bassQuiz = viewModel.bassQuiz {

                QuizPlayerView(
                    title: bassQuiz.title,
                    questions: bassQuiz.questions,
                    isShowingQuiz: $showBassQuiz
                )
            }
        }

        // MARK: - Load Quizzes

        .onAppear {
            viewModel.loadQuizzes()
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
        showMenu: $showMenu,
        viewModel: QuizViewModel(
            quizRepository: LocalQuizRepository()
        )
    )
}
