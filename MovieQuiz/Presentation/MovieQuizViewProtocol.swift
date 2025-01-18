//
//  MovieQuizViewProtocol.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 18.01.2025.
//
protocol MovieQuizViewProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func updateUI(with viewModel: QuizStepViewModel)
    func showFinalResults(with alertModel: AlertModel)
    func showAnswerResult(isCorrect: Bool)
}
