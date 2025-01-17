//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Кротов Дмитрий Александрович on 13.01.2025.
//

import Foundation


struct MostPopularMovies: Codable {
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL

    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        return URL(string: imageUrlString) ?? imageURL
    }

    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
