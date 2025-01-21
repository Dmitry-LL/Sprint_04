//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 20.12.2024.
//

import Foundation
protocol QuestionFactoryProtocol {
    func loadData()
    func requestNextQuestion()
    func resetQuestions()
}
