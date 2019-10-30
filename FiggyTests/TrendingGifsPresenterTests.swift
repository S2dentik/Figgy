import XCTest
@testable import Figgy

final class TrendingGifsPresenterTests: XCTestCase {

    var subject: TrendingGifsPresenter!

    var view: MockTrendingGifsViewInput!
    var fetcher: MockGiphyFetcher!

    override func setUp() {
        super.setUp()

        fetcher = MockGiphyFetcher()
        view = MockTrendingGifsViewInput()

        subject = TrendingGifsPresenter(view: view, fetcher: fetcher)
    }

    func test_collectionScrolled_whenIsCloseToBottom_requestsTrendingGifs() {
        // GIVEN

        // WHEN
        subject.collectionScrolled(to: 200, totalHeight: 210)

        // THEN
        XCTAssertEqual(fetcher.fetchTrendingCalledOffsets, [0])
    }

    func test_collectionScrolled_subsequentEvents_doNotTriggerTwoRequests() {
        // GIVEN

        // WHEN
        subject.collectionScrolled(to: 200, totalHeight: 210)
        subject.collectionScrolled(to: 201, totalHeight: 210)

        // THEN
        XCTAssertEqual(fetcher.fetchTrendingCalledOffsets, [0])
    }

    func test_collectionScrolled_afterCollectionWasNotAtTheBottomAndNowIs_triggersSecondRequestWithCorrectOffset() {
        // GIVEN
        fetcher.fetchTrendingStub = .success([Gif(id: "123", type: "gif", url: URL(string: "someURL")!, videoURL: URL(string: "someOtherURL")!)])

        // WHEN
        subject.collectionScrolled(to: 200, totalHeight: 210)
        subject.collectionScrolled(to: 201, totalHeight: 300)
        subject.collectionScrolled(to: 290, totalHeight: 300)

        // THEN
        XCTAssertEqual(fetcher.fetchTrendingCalledOffsets, [0, 1])
    }

    func test_collectionScrolled_successfulResponse_insertsItems() {
        // GIVEN
        let gifs = [Gif(id: "123", type: "gif", url: URL(string: "someURL")!, videoURL: URL(string: "someOtherURL")!)]
        fetcher.fetchTrendingStub = .success(gifs)

        // WHEN
        subject.collectionScrolled(to: 200, totalHeight: 210)

        // THEN
        XCTAssertEqual(subject.gifs, gifs)
        XCTAssertEqual(view.insertItemsValues.first, [IndexPath(item: 0, section: 0)])
    }

    func test_configureCell_callsConfigureBlockWithData() {
        // GIVEN
        let expectedData = "12345".data(using: .utf8)!
        fetcher.loadImageStub = .success(expectedData)
        subject.gifs = [Gif(id: "123", type: "gif", url: URL(string: "someURL")!, videoURL: URL(string: "someOtherURL")!)]

        var actualData: Data?

        // WHEN
         _ = subject.configureCell(at: IndexPath(item: 0, section: 0),
                              configure: { actualData = $0 })

        // THEN
        XCTAssertEqual(actualData, expectedData)
    }

    func test_configureCell_returnsCancellableRequest() {
        // GIVEN
        fetcher.loadImageStub = .success("12345".data(using: .utf8)!)
        subject.gifs = [Gif(id: "123", type: "gif", url: URL(string: "someURL")!, videoURL: URL(string: "someOtherURL")!)]

        let task = MockNetworkTask()
        fetcher.loadImageTaskStub = task

        // WHEN
        let cancel = subject.configureCell(at: IndexPath(item: 0, section: 0),
                              configure: { _ in })
        cancel()

        // THEN
        XCTAssert(task.cancelCalled)
    }
}
