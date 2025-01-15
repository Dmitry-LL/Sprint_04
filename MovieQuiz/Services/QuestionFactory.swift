//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 17.12.2024.
//

import Foundation
final class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    private var usedIndices: Set<Int> = []
    var delegate: QuestionFactoryDelegate?

    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }

    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self, !self.movies.isEmpty else {
                DispatchQueue.main.async {
                    self?.delegate?.didFailToLoadData(with: NSError(domain: "NoMovies", code: 404, userInfo: [NSLocalizedDescriptionKey: "No movies available"]))
                }
                return
            }

            var index: Int
            repeat {
                index = Int.random(in: 0..<self.movies.count)
            } while self.usedIndices.contains(index) && self.usedIndices.count < self.movies.count

            self.usedIndices.insert(index)

            guard let movie = self.movies[safe: index] else { return }

            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLoadData(with: error)
                }
                return
            }

            let rating = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7

            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)

            DispatchQueue.main.async {
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }

    func resetQuestions() {
        usedIndices.removeAll()
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
}
