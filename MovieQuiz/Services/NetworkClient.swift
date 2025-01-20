import Foundation

final class NetworkClient: NetworkRouting {
    func fetch(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "UnknownError", code: -1, userInfo: nil)))
            }
        }
        task.resume()
    }
}
