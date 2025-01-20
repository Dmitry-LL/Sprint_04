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

final class MoviesLoader {
    // MARK: - Properties
    private let networkClient: NetworkRouting
    private let moviesURL = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf")!

    // MARK: - Init
    init(networkClient: NetworkRouting) {
        self.networkClient = networkClient
    }

    // MARK: - Public Methods
    func loadMovies(completion: @escaping (Result<MoviesResponse, Error>) -> Void) {
        networkClient.fetch(url: moviesURL) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MoviesResponse.self, from: data)
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
