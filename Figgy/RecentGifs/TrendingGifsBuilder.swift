import Foundation

enum TrendingGifsBuilder {
    static func build() -> TrendingGifsViewController {
        let vc = TrendingGifsViewController.instantiate()
        let presenter = TrendingGifsPresenter(view: vc, fetcher: GiphyFetcher(network: URLSession.shared))
        vc.output = presenter

        return vc
    }
}
