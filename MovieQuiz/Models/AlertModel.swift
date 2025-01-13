//
//  AlerttModel.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 23.12.2024.
//

import Foundation
struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    let completion: (() -> Void)?
}
