import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService = StatisticService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageView()
        alertPresenter = AlertPresenter(viewController: self)
        questionFactory?.loadData()
        imageView.contentMode = .scaleAspectFill
        showLoadingIndicator()
        setupActivityIndicator()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticService()
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            showResults()
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        show(quiz: viewModel)
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        handleAnswer(true)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        handleAnswer(false)
    }
    
    private func handleAnswer(_ givenAnswer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let isCorrect = currentQuestion.correctAnswer == givenAnswer
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        currentQuestionIndex += 1
        if currentQuestionIndex < questionsAmount {
            questionFactory?.requestNextQuestion()
        } else {
            showResults()
        }
    }
    
    private func showResults() {
        endGame(correctAnswers: correctAnswers, totalQuestions: questionsAmount)
        
        let alertModel = AlertModel(
            title: "Раунд окончен!",
            message: "Ваш результат: \(correctAnswers) из \(questionsAmount).",
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.restartGame()
            }
        )
        alertPresenter?.showAlert(model: alertModel)
    }
    
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        (questionFactory as? QuestionFactory)?.resetQuestions()
        questionFactory?.requestNextQuestion()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func endGame(correctAnswers: Int, totalQuestions: Int) {
        statisticService.store(correct: correctAnswers, total: totalQuestions)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func setupActivityIndicator() {
        activityIndicator?.hidesWhenStopped = true
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
        
        alertPresenter?.showAlert(model: model)
    }
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
        func didFailToLoadData(with error: Error) {
            showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
        }
    }

