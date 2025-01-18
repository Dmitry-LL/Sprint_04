//
//  MovieQuizPresenter.swift.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 18.01.2025.
//
import UIKit

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    weak var view: MovieQuizViewProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var correctAnswers: Int = 0
    let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0

    init(view: MovieQuizViewProtocol, questionFactory: QuestionFactoryProtocol) {
        self.view = view
        self.questionFactory = questionFactory
    }

    func loadData() {
        view?.showLoadingIndicator()
        questionFactory?.loadData()
    }

    func didLoadNextQuestion(question: QuizQuestion) {
        currentQuestion = question
        let viewModel = convert(model: question)
        view?.updateUI(with: viewModel)
    }

    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }

    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let isCorrect = (isYes == currentQuestion.correctAnswer)
        if isCorrect {
            correctAnswers += 1
        }
        view?.showAnswerResult(isCorrect: isCorrect)

        if isLastQuestion() {
            showResults()
        } else {
            switchToNextQuestion()
        }
    }

    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    private func switchToNextQuestion() {
        currentQuestionIndex += 1
        questionFactory?.requestNextQuestion()
    }

    func reset() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            showResults()
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        view?.updateUI(with: viewModel)
    }

    func didLoadDataFromServer() {
        view?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        view?.hideLoadingIndicator()
        view?.showNetworkError(message: error.localizedDescription)
    }

    private func showResults() {
        let percentage = Int((Double(correctAnswers) / Double(questionsAmount)) * 100)
        let resultModel = AlertModel(
            title: "Раунд окончен!",
            message: "Вы правильно ответили на \(correctAnswers) из \(questionsAmount) (\(percentage)%).",
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.reset()
                self?.questionFactory?.requestNextQuestion()
            }
        )
        view?.showFinalResults(with: resultModel)
    }
}
