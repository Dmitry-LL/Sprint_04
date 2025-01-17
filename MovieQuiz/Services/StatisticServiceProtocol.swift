//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 30.12.2024.
//

import Foundation
protocol StatisticServiceProtocol: Any {
    func store(correct: Int, total: Int)
    func getStatistics() -> (total: Int, correct: Int)
    var gamesCount: Int { get }
     var bestGame: GameResult { get }
     var totalAccuracy: Double { get }
 }



