//
//  AlerttModel.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 23.12.2024.
//

import Foundation
struct QuizAlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
