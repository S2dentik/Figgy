import UIKit

enum RandomGifBuilder {
    static func build(with gif: Gif?) -> RandomGifViewController {
        let vc = RandomGifViewController.instantiate()
        let presenter = RandomGifPresenter(view: vc, fetcher: GiphyFetcher(network: URLSession.shared))
        vc.gif = gif
        vc.output = presenter

        return vc
    }
}
