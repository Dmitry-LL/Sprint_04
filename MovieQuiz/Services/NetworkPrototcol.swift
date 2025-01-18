//
//  NetworkPrototcol.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 18.01.2025.
//

import Foundation
protocol NetworkRouting {
    func fetch(url: URL, completion handler: @escaping (Result<Data, Error>) -> Void)
    func loadMovies(completion: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

