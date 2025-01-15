//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 20.12.2024.
//

import Foundation
protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
       func didLoadDataFromServer()
       func didFailToLoadData(with error: Error)
   }
