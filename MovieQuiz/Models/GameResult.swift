//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 30.12.2024.
//

import Foundation
struct GameResult: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: self)
    }
}
extension GameResult {
    func isBetterThan(_ other: GameResult) -> Bool {
        return self.correct > other.correct ||
               (self.correct == other.correct && self.total < other.total)
    }
}

