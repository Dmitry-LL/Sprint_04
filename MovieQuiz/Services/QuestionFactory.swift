import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoader
    private var movies: [Movie] = [] // Список фильмов
    
    init(moviesLoader: MoviesLoader, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // Загрузка данных с сервера
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let moviesResponse):
                    self?.movies = moviesResponse.items
                    self?.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self?.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    // Перемешивание вопросов (сброс состояния)
    func resetQuestions() {
        movies.shuffle()
    }
    
    // Запрос следующего вопроса
    func requestNextQuestion() {
        guard !movies.isEmpty else { return }
        let index = Int.random(in: 0..<movies.count)
        let movie = movies[index]
        
        guard let imageURL = URL(string: movie.image) else { return }
        let text = "Рейтинг этого фильма больше чем 7?"
        let correctAnswer = Float(movie.imDbRating) ?? 0 > 7
        
        // Загрузка изображения и создание вопроса
        URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
            DispatchQueue.main.async {
                if let data = data {
                    let question = QuizQuestion(image: data, text: text, correctAnswer: correctAnswer)
                    self?.delegate?.didReceiveNextQuestion(question: question)
                } else {
                    print("Ошибка загрузки изображения: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                }
            }
        }.resume()
    }
}
