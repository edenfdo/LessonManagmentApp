//
//  QuizViewModel.swift
//  LessonManagmentApp
//
//  Created by Eden Fernando on 12/9/2026.
//

import Foundation
import Combine

final class QuizViewModel: ObservableObject {

    @Published var quizzes: [Quiz] = []

    private let quizRepository: QuizRepository

    init(
        quizRepository: QuizRepository
    ) {
        self.quizRepository = quizRepository
    }

    func loadQuizzes() {
        quizzes = quizRepository.fetchQuizzes()
    }

    var trebleQuiz: Quiz? {
        quizzes.first {
            $0.title == "Treble Clef Note Reading"
        }
    }

    var bassQuiz: Quiz? {
        quizzes.first {
            $0.title == "Bass Clef Note Reading"
        }
    }
}
