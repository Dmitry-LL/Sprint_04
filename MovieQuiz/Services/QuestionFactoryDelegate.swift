//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 20.12.2024.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveQuestion(question: QuizQuestion?)
}
