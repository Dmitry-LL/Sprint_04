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
        setupQuestionFactory()
        alertPresenter = AlertPresenter(viewController: self)
        questionFactory?.requestNextQuestion()
        imageView.contentMode = .scaleAspectFill
        showLoadingIndicator()
        setupActivityIndicator()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticService()
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func setupQuestionFactory() {
        let questions = [
            QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
            QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
            QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
            QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
        ]
        questionFactory = QuestionFactory(questions: questions)
        questionFactory?.delegate = self
    }
    
    func didReceiveQuestion(question: QuizQuestion?) {
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
        // Сохраняем статистику
        endGame(correctAnswers: correctAnswers, totalQuestions: questionsAmount)
        
        let alertModel = AlertModel(
            title: "Раунд окончен!",
            message: """
            Ваш результат: \(correctAnswers) из \(questionsAmount).
            Всего игр: \(statisticService.gamesCount)
            Лучший результат: \(statisticService.bestGame.correct) из \(statisticService.bestGame.total) (\(statisticService.bestGame.date.toString()))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """,
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
        
        // Сбрасываем использованные вопросы
        (questionFactory as? QuestionFactory)?.resetQuestions()
        
        // Запрашиваем первый вопрос
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
    private func sendFirstRequest() {
        guard let url = URL(string: "https://tv-api.com/en/api/top250movies/k_zcuw1ytf") else {
            return
        }
        let request = URLRequest(url: url)
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
        }
        task.resume()
    }
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
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
    private func setupActivityIndicator() {
        activityIndicator?.hidesWhenStopped = true
        if let activityIndicator = activityIndicator {
            view.addSubview(activityIndicator)
        }
    }
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
