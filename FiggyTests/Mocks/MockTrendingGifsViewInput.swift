@testable import Figgy
import Foundation

final class MockTrendingGifsViewInput: TrendingGifsViewInput {

    var insertItemsValues = [[IndexPath]]()
    func insertItems(at indexPaths: [IndexPath]) {
        insertItemsValues.append(indexPaths)
    }

    var displayErrorValues = [String]()
    func displayError(_ error: String) {
        displayErrorValues.append(error)
    }
}
