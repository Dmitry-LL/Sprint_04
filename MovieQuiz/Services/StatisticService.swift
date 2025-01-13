//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 30.12.2024.
//
import Foundation
final class StatisticService {
    private let storage: UserDefaults = .standard

    private enum Keys {
        static let gamesCount = "gamesCount"
        static let correctAnswers = "correctAnswers"
        static let totalQuestions = "totalQuestions"
        static let bestGame = "bestGame"
    }

    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount)
        }
    }

    var bestGame: GameResult {
        get {
            guard let data = storage.data(forKey: Keys.bestGame),
                  let result = try? JSONDecoder().decode(GameResult.self, from: data) else {
                return GameResult(correct: 0, total: 0, date: Date())
            }
            return result
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                storage.set(data, forKey: Keys.bestGame)
            }
        }
    }

    var totalAccuracy: Double {
        let correctAnswers = storage.integer(forKey: Keys.correctAnswers)
        let totalQuestions = storage.integer(forKey: Keys.totalQuestions)
        return totalQuestions > 0 ? (Double(correctAnswers) / Double(totalQuestions)) * 100 : 0
    }

    func store(correct count: Int, total amount: Int) {
        // Обновляем количество игр
        gamesCount += 1

        // Обновляем правильные ответы и общее число вопросов
        let currentCorrect = storage.integer(forKey: Keys.correctAnswers)
        let currentTotal = storage.integer(forKey: Keys.totalQuestions)
        storage.set(currentCorrect + count, forKey: Keys.correctAnswers)
        storage.set(currentTotal + amount, forKey: Keys.totalQuestions)

        // Проверяем и обновляем лучший результат
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
    }
}
