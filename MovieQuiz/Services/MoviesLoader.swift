import Foundation

struct MoviesResponse: Decodable {
    let items: [Movie]
}

struct Movie: Decodable {
    let id: String
    let title: String
    let year: String
    let image: String
    let rank: String
    let rankUpDown: String
    let crew: String
    let imDbRating: String
    let imDbRatingCount: String
}

final class MoviesLoader: NetworkRouting {
    private let networkClient: NetworkRouting
    private let moviesURL = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf")! // 

    init(networkClient: NetworkRouting) {
        self.networkClient = networkClient
    }

    // Реализация протокола NetworkRouting
    func fetch(url: URL, completion handler: @escaping (Result<Data, Error>) -> Void) {
        networkClient.fetch(url: url, completion: handler)
    }

    // Загрузка фильмов
    func loadMovies(completion: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: moviesURL) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MostPopularMovies.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
