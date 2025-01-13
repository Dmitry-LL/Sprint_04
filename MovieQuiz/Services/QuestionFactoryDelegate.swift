//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 20.12.2024.
//

import Foundation
protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
