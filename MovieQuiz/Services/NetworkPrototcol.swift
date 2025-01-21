//
//  NetworkPrototcol.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 18.01.2025.
//

import Foundation
protocol NetworkRouting {
    func fetch(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

