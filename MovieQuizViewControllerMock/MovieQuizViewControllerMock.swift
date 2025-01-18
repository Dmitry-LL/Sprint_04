//
//  MovieQuizViewControllerMock.swift
//  MovieQuizViewControllerMock
//
//  Created by Кротов Дмитрий Александрович on 19.01.2025.
//
import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewProtocol {
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func showNetworkError(message: String) {}
    func updateUI(with viewModel: QuizStepViewModel) {}
    func showFinalResults(with alertModel: AlertModel) {}
    func showAnswerResult(isCorrect: Bool) {}
}

import Foundation
@testable import MovieQuiz

final class QuestionFactoryMock: QuestionFactoryProtocol {
    func resetQuestions() {
        // Реализация для тестов
    }
    
    func loadData() {
        // Реализация для тестов
    }
    
    func requestNextQuestion() {
        // Реализация для тестов
    }
}
