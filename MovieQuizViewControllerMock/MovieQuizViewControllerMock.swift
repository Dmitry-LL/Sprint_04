import Foundation
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewProtocol {
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func showNetworkError(message: String) {}
    func updateUI(with viewModel: QuizStepViewModel) {}
    func showFinalResults(with alertModel: AlertModel) {}
    func showAnswerResult(isCorrect: Bool) {}
}
