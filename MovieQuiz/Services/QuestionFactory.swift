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
    
    private let questions: [QuizQuestion]
        private var usedIndices: Set<Int> = [] // Хранит индексы уже заданных вопросов
        weak var delegate: QuestionFactoryDelegate?

        init(questions: [QuizQuestion]) {
            self.questions = questions
        }

        func requestNextQuestion() {
            // Найти доступные индексы (те, которые еще не использованы)
            let availableIndices = Array(0..<questions.count).filter { !usedIndices.contains($0) }
            
            guard let index = availableIndices.randomElement() else {
                // Если вопросов больше нет, передаем nil
                delegate?.didReceiveQuestion(question: nil)
                return
            }
            
            // Помечаем вопрос как использованный
            usedIndices.insert(index)
            
            // Передаем следующий вопрос делегату
            let question = questions[index]
            delegate?.didReceiveQuestion(question: question)
        }

        func resetQuestions() {
            usedIndices.removeAll() // Сбрасываем использованные индексы
        }
    }
