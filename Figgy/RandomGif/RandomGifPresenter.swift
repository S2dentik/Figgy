import Foundation

protocol RandomGifViewOutput {
    func viewTapped()
}

final class RandomGifPresenter {

    private let fetcher: GiphyFetcher
    private weak var view: RandomGifViewInput?

    private lazy var timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
        self.map { $0.fetcher.fetchRandom(completion: $0.handleFetchResult) }
    }

    init(view: RandomGifViewInput, fetcher: GiphyFetcher) {
        self.view = view
        self.fetcher = fetcher

        _ = timer
    }

    private func handleFetchResult(_ result: Result<Gif, FetchingError>) {
        switch result {
        case .success(let gif): view?.play(gif)
        case .failure(let error): print("ERROR: \(error.localizedDescription)")
        }
    }
}

extension RandomGifPresenter: RandomGifViewOutput {
    func viewTapped() {
        view?.pop()
    }
}
