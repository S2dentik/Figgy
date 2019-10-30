@testable import Figgy
import Foundation

final class MockGiphyFetcher: GiphyFetcherType {

    var fetchTrendingCalledOffsets = [Int]()
    var fetchTrendingStub: Result<[Gif], FetchingError>?
    func fetchTrending(offset: Int, completion: @escaping (Result<[Gif], FetchingError>) -> Void) {
        fetchTrendingCalledOffsets.append(offset)
        fetchTrendingStub.map(completion)
    }

    var loadImageCalledURLs = [URL]()
    var loadImageStub: Result<Data, RequestError>?
    var loadImageTaskStub: MockNetworkTask?
    func loadImage(url: URL, completion: @escaping (Result<Data, RequestError>) -> Void) -> NetworkTask {
        loadImageCalledURLs.append(url)
        loadImageStub.map(completion)

        return loadImageTaskStub ?? MockNetworkTask()
    }

    var fetchRandomStub: Result<Gif, FetchingError>?
    func fetchRandom(completion: @escaping (Result<Gif, FetchingError>) -> Void) {
        fetchRandomStub.map(completion)
    }
}
