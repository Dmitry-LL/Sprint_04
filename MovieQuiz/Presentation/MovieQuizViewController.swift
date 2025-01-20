import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    // MARK: - Properties
    private var alertPresenter: AlertPresenter?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
            super.viewDidLoad()
            configureImageView()
            alertPresenter = AlertPresenter(viewController: self)
            
            // Передаем questionFactory
            let networkClient = NetworkClient() // Создаем экземпляр NetworkClient
            let moviesLoader = MoviesLoader(networkClient: networkClient) // Передаем его в MoviesLoader
            let questionFactory = QuestionFactory(moviesLoader: moviesLoader, delegate: nil)
            
            presenter = MovieQuizPresenter(view: self, questionFactory: questionFactory)
            presenter.loadData()
        }
        
    
    // MARK: - Private Methods
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.clear.cgColor
    }

    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.didAnswer(isYes: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.didAnswer(isYes: false)
    }
}
extension MovieQuizViewController: MovieQuizViewProtocol {
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    func showNetworkError(message: String) {
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                self?.presenter.loadData()
            }
        alertPresenter?.showAlert(model: model)
    }

    func updateUI(with viewModel: QuizStepViewModel) {
        imageView.image = viewModel.image
        textLabel.text = viewModel.question
        counterLabel.text = viewModel.questionNumber
    }

    func showFinalResults(with alertModel: AlertModel) {
        alertPresenter?.showAlert(model: alertModel)
    }

    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.imageView.layer.borderWidth = 0
        }
    }
}
