//
//  MovieQuizPresenter.swift.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 18.01.2025.
//
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Public Properties
    weak var view: MovieQuizViewProtocol?
    let questionsAmount: Int = 10
    private let statisticService: StatisticServiceProtocol
    
    // MARK: - Private Properties
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0

    // MARK: - Init
    init(view: MovieQuizViewProtocol, questionFactory: QuestionFactoryProtocol, statisticService: StatisticServiceProtocol) {
            self.view = view
            self.questionFactory = questionFactory
            self.statisticService = statisticService
    }

    // MARK: - Public Methods
    func loadData() {
        view?.showLoadingIndicator()
        questionFactory?.loadData()
    }

    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let isCorrect = isYes == currentQuestion.correctAnswer
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

    func reset() {
        currentQuestionIndex = 0
        correctAnswers = 0
        loadData()
    }

    // MARK: - QuestionFactoryDelegate
    func didLoadNextQuestion(question: QuizQuestion) {
        handleNextQuestion(question: question)
    }

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            showResults()
            return
        }
        handleNextQuestion(question: question)
    }

    func didLoadDataFromServer() {
        view?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        handleLoadingError(error: error)
    }

    // MARK: - Private Methods
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    private func switchToNextQuestion() {
        currentQuestionIndex += 1
        questionFactory?.requestNextQuestion()
    }

    private func handleNextQuestion(question: QuizQuestion) {
        currentQuestion = question
        let viewModel = convert(model: question)
        view?.updateUI(with: viewModel)
    }

    private func handleLoadingError(error: Error) {
        view?.hideLoadingIndicator()
        view?.showNetworkError(message: error.localizedDescription)
    }
    func showResults() {
        let correctAnswers = self.correctAnswers
        let questionsAmount = self.questionsAmount
        let gamesCount = statisticService.gamesCount
        let bestGame = statisticService.bestGame
        let totalAccuracy = statisticService.totalAccuracy

        let alertMessage = """
        Ваш результат: \(correctAnswers) из \(questionsAmount).
        Всего игр: \(gamesCount)
        Лучший результат: \(bestGame.correct) из \(bestGame.total) (\(bestGame.date.toString()))
        Средняя точность: \(String(format: "%.2f", totalAccuracy))%
        """

        let alertModel = AlertModel(
            title: "Игра окончена",
            message: alertMessage,
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.reset()
                self?.questionFactory?.requestNextQuestion()
            }
        )
        view?.showFinalResults(with: alertModel)
    }

    internal func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
}
