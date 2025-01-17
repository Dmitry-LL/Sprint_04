//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 13.01.2025.
//

import Foundation
/// Отвечает за загрузку данных по URL
enum NetworkError: Error {
    case invalidURL
    case dataLoadingFailed
}

final class NetworkClient {
    func fetch(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.dataLoadingFailed))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}
