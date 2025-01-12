//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 17.12.2024.
//

import Foundation
//class QuestionFactory: QuestionFactoryProtocol {
    
    //weak var delegate: QuestionFactoryDelegate?
    //private let questions: [QuizQuestion] = [
        //QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        //QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        //QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        //QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        //QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        //QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        //QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        //QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    //    QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
  //      QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
//    ]
final class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
      //  private weak var delegate: QuestionFactoryDelegate?

        //init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
          //  self.moviesLoader = moviesLoader
            //self.delegate = delegate
        //}
    
    private var movies: [MostPopularMovie] = []
    
    private let questions: [QuizQuestion]
        private var usedIndices: Set<Int> = [] // Хранит индексы уже заданных вопросов
        weak var delegate: QuestionFactoryDelegate?

        init(questions: [QuizQuestion]) {
            self.questions = questions
        }

    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
           
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            let question = QuizQuestion(image: imageData,
                                         text: text,
                                         correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate.didReceiveNextQuestion(question: question)
            }
        }
    } 

        func resetQuestions() {
            usedIndices.removeAll() // Сбрасываем использованные индексы
        }
    func loadData() {
           moviesLoader.loadMovies { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .success(let mostPopularMovies):
                   self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                   self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
               case .failure(let error):
                   self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
               }
           }
       }
    
    }

