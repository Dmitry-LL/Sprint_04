//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 13.01.2025.
//

import Foundation
protocol MoviesLoading {
    func loadMovies(completion: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

final class MoviesLoader: MoviesLoading {
    private let networkClient = NetworkClient()
    private let apiUrl = "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf"
    
    func loadMovies(completion: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        guard let url = URL(string: apiUrl) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        networkClient.fetch(url: url) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let movies = try decoder.decode(MostPopularMovies.self, from: data)
                    completion(.success(movies))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
