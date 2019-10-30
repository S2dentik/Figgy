import Foundation
import CoreGraphics

protocol TrendingGifsViewOutput {
    var gifs: [Gif] { get }
    func collectionScrolled(to y: CGFloat, totalHeight: CGFloat)
    func configureCell(at indexPath: IndexPath,
                       configure: @escaping (Data?) -> Void) -> () -> Void
}

final class TrendingGifsPresenter: TrendingGifsViewOutput {

    private let fetcher: GiphyFetcherType
    private weak var view: TrendingGifsViewInput?

    // this is used to deny multiple requests from collection scrolled while it is still loading
    private var isLoading = false
    private var offset: Int { gifs.count }
    var gifs = [Gif]() {
        didSet {
            let indexPaths = (oldValue.count..<gifs.count)
                .map { IndexPath(item: $0, section: 0) }
            view?.insertItems(at: indexPaths)
        }
    }

    init(view: TrendingGifsViewInput, fetcher: GiphyFetcherType) {
        self.view = view
        self.fetcher = fetcher
    }

    func collectionScrolled(to y: CGFloat, totalHeight: CGFloat) {
        let scrolledToBottom = y + 20 > totalHeight
        if isLoading && scrolledToBottom { return }
        isLoading = scrolledToBottom
        guard scrolledToBottom else { return }
        fetcher.fetchTrending(offset: offset) { [weak self] result in
            UI {
                switch result {
                case .success(let gifs): self?.gifs += gifs
                case .failure(let error): self?.view?.displayError(error.localizedDescription)
                }
            }
        }
    }

    func configureCell(at indexPath: IndexPath, configure: @escaping (Data?) -> Void) -> () -> Void {
        let task = fetcher.loadImage(url: gifs[indexPath.item].url) { result in
            UI { configure(try? result.get()) }
        }
        return task.cancel
    }
}
