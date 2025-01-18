import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: NetworkRouting
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: NetworkRouting, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] (result: Result<MostPopularMovies, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let mostPopularMovies):
                    self?.movies = mostPopularMovies.items
                    self?.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self?.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func resetQuestions() {
        movies.shuffle()
    }
    
    func requestNextQuestion() {
        guard !movies.isEmpty else { return }
        let index = Int.random(in: 0..<movies.count)
        let movie = movies[index]
        
        let rating = Float(movie.rating) ?? 0
        let text = "Рейтинг этого фильма больше чем 7?"
        let correctAnswer = rating > 7
        
        URLSession.shared.dataTask(with: movie.imageURL) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    let question = QuizQuestion(image: data, text: text, correctAnswer: correctAnswer)
                    self?.delegate?.didReceiveNextQuestion(question: question)
                } else {
                    print("Failed to load image data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }.resume()
    }
}
