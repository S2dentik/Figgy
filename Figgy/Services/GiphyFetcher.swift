import Foundation

enum FetchingError: Error {
    case requestError(RequestError)
    case invalidURL
    case decodingError(DecodingError)
    case genericError(Error)

    var localizedDescription: String {
        switch self {
        case .requestError(let error): return "Request error: \(error.localizedDescription)"
        case .invalidURL: return "Invalid URL"
        case .decodingError(let error): return "Decoding error:  \(error.localizedDescription)"
        case .genericError(let error): return error.localizedDescription
        }
    }
}

protocol GiphyFetcherType {
    func fetchTrending(offset: Int, completion: @escaping (Result<[Gif], FetchingError>) -> Void)
    func loadImage(url: URL, completion: @escaping (Result<Data, RequestError>) -> Void) -> NetworkTask
    func fetchRandom(completion: @escaping (Result<Gif, FetchingError>) -> Void)
}

final class GiphyFetcher: GiphyFetcherType {

    enum Endpoint: String {
        case random
        case trending
    }

    let network: Network

    init(network: Network) {
        self.network = network
    }

    func fetchTrending(offset: Int, completion: @escaping (Result<[Gif], FetchingError>) -> Void) {
        guard let url = trendingURL(for: offset) else { return completion(.failure(.invalidURL)) }
        performAndDecode(url: url) { (result: Result<GifResponse<[Gif]>, FetchingError>) in
            completion(result.map { $0.value })
        }
    }

    func fetchRandom(completion: @escaping (Result<Gif, FetchingError>) -> Void) {
        guard let url = randomURL() else { return completion(.failure(.invalidURL)) }
        performAndDecode(url: url) { (result: Result<GifResponse<Gif>, FetchingError>) in
            completion(result.map { $0.value })
        }
    }

    func performAndDecode<D: Decodable>(url: URL, completion: @escaping (Result<D, FetchingError>) -> Void) {
        network.dataTask(with: url) { result in
            completion(
                result
                    .mapError(FetchingError.requestError)
                    .flatMap { data in
                        do {
                            return .success(try JSONDecoder().decode(D.self, from: data))
                        } catch let error as DecodingError {
                            return .failure(.decodingError(error))
                        } catch {
                            return .failure(.genericError(error))
                        }
            })
        }.resume()
    }

    func loadImage(url: URL, completion: @escaping (Result<Data, RequestError>) -> Void) -> NetworkTask{
        let task = network.dataTask(with: url, completion: completion)
        task.resume()

        return task
    }

    private func trendingURL(for offset: Int) -> URL? {
        return url(for: .trending, queryItems: ["offset": "\(offset)"])
    }

    private func randomURL() -> URL? {
        return url(for: .random, queryItems: [:])
    }

    private func url(for endpoint: Endpoint, queryItems: [String: String]) -> URL? {
        guard let url = URL(string: "https://api.giphy.com/v1/gifs/\(endpoint.rawValue)") else { return nil }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems
            .map { URLQueryItem(name: $0.key, value: $0.value) } +
            [URLQueryItem(name: "api_key", value: "dc6zaTOxFJmzC")]
        return components.url
    }
}
