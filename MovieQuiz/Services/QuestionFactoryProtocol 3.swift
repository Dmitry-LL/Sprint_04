//
//  QuestionFactoryProtocol 3.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 23.12.2024.
//


protocol QuestionFactoryProtocol: AnyObject {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
}