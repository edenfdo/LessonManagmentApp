//
//  QuizPlayerView.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 11/9/2026.
//

import SwiftUI

struct QuizPlayerView: View {

    let title: String
    let questions: [QuizQuestion]

    @Binding var isShowingQuiz: Bool

    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var hasSubmitted = false
    @State private var score = 0
    @State private var quizFinished = false

    var body: some View {

        ZStack {

            Color(.systemBackground)
                .ignoresSafeArea()

            ScrollView {

                VStack(
                    alignment: .leading,
                    spacing: 24
                ) {

                    // MARK: - Header

                    HStack {

                        Text(title)
                            .font(.title2)
                            .fontWeight(.bold)

                        Spacer()

                        Button {
                            isShowingQuiz = false
                        } label: {

                            Image(systemName: "xmark")
                                .font(.title3)
                        }
                    }

                    if quizFinished {

                        // MARK: - Quiz Complete

                        VStack(
                            alignment: .center,
                            spacing: 20
                        ) {

                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 70))
                                .foregroundStyle(.green)

                            Text("Quiz Complete!")
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Text(
                                "You scored \(score) out of \(questions.count)"
                            )
                            .font(.title3)

                            Button {

                                restartQuiz()

                            } label: {

                                Text("Try Again")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .cornerRadius(12)
                            }

                            Button {

                                isShowingQuiz = false

                            } label: {

                                Text("Back to Quizzes")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        .gray.opacity(0.15)
                                    )
                                    .foregroundStyle(.primary)
                                    .cornerRadius(12)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)

                    } else {

                        // MARK: - Current Question

                        let question =
                            questions[currentQuestionIndex]

                        Text(
                            "Question \(currentQuestionIndex + 1) of \(questions.count)"
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                        Text("What note is shown?")
                            .font(.title3)
                            .fontWeight(.semibold)

                        // MARK: - Note Image

                        Image(question.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: 220
                            )
                            .padding()
                            .background(
                                .gray.opacity(0.08)
                            )
                            .cornerRadius(14)

                        // MARK: - Answers

                        VStack(spacing: 12) {

                            ForEach(
                                question.answers,
                                id: \.self
                            ) { answer in

                                Button {

                                    if !hasSubmitted {
                                        selectedAnswer = answer
                                    }

                                } label: {

                                    HStack {

                                        Text(answer)
                                            .fontWeight(.semibold)

                                        Spacer()

                                        if selectedAnswer == answer {

                                            Image(
                                                systemName: "checkmark.circle.fill"
                                            )
                                        }
                                    }
                                    .padding()
                                    .frame(
                                        maxWidth: .infinity
                                    )
                                    .background(
                                        answerBackground(
                                            answer,
                                            question: question
                                        )
                                    )
                                    .foregroundStyle(
                                        answerTextColor(
                                            answer,
                                            question: question
                                        )
                                    )
                                    .cornerRadius(12)
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        // MARK: - Feedback

                        if hasSubmitted {

                            if selectedAnswer ==
                                question.correctAnswer {

                                Text("Correct!")
                                    .font(.headline)
                                    .foregroundStyle(.green)

                            } else {

                                Text(
                                    "Not quite. The correct answer is \(question.correctAnswer)."
                                )
                                .font(.headline)
                                .foregroundStyle(.red)
                            }
                        }

                        // MARK: - Main Button

                        Button {

                            if hasSubmitted {

                                goToNextQuestion()

                            } else {

                                checkAnswer(
                                    question: question
                                )
                            }

                        } label: {

                            Text(
                                hasSubmitted
                                ? nextButtonTitle
                                : "Check Answer"
                            )
                            .fontWeight(.semibold)
                            .frame(
                                maxWidth: .infinity
                            )
                            .padding()
                            .background(
                                selectedAnswer == nil &&
                                !hasSubmitted
                                ? Color.gray.opacity(0.3)
                                : Color.blue
                            )
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                        }
                        .disabled(
                            selectedAnswer == nil &&
                            !hasSubmitted
                        )
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - Check Answer

    private func checkAnswer(
        question: QuizQuestion
    ) {

        hasSubmitted = true

        if selectedAnswer ==
            question.correctAnswer {

            score += 1
        }
    }

    // MARK: - Next Question

    private func goToNextQuestion() {

        if currentQuestionIndex <
            questions.count - 1 {

            currentQuestionIndex += 1
            selectedAnswer = nil
            hasSubmitted = false

        } else {

            quizFinished = true
        }
    }

    // MARK: - Restart Quiz

    private func restartQuiz() {

        currentQuestionIndex = 0
        selectedAnswer = nil
        hasSubmitted = false
        score = 0
        quizFinished = false
    }

    // MARK: - Next Button Title

    private var nextButtonTitle: String {

        if currentQuestionIndex ==
            questions.count - 1 {

            return "Finish Quiz"
        }

        return "Next Question"
    }

    // MARK: - Answer Styling

    private func answerBackground(
        _ answer: String,
        question: QuizQuestion
    ) -> Color {

        if !hasSubmitted {

            return selectedAnswer == answer
            ? Color.blue.opacity(0.15)
            : Color.gray.opacity(0.12)
        }

        if answer == question.correctAnswer {

            return Color.green.opacity(0.18)
        }

        if answer == selectedAnswer {

            return Color.red.opacity(0.18)
        }

        return Color.gray.opacity(0.12)
    }

    private func answerTextColor(
        _ answer: String,
        question: QuizQuestion
    ) -> Color {

        if hasSubmitted &&
            answer == question.correctAnswer {

            return .green
        }

        if hasSubmitted &&
            answer == selectedAnswer &&
            answer != question.correctAnswer {

            return .red
        }

        return .primary
    }
}

#Preview {

    @Previewable
    @State var isShowingQuiz = true

    let questions = [

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
        )
    ]

    QuizPlayerView(
        title: "Treble Clef Note Reading",
        questions: questions,
        isShowingQuiz: $isShowingQuiz
    )
}
