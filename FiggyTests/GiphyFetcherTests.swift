import XCTest
@testable import Figgy

final class GiphyFetcherTests: XCTestCase {

    var subject: GiphyFetcher!

    var network: MockNetwork!

    override func setUp() {
        super.setUp()

        network = MockNetwork()

        subject = GiphyFetcher(network: network)
    }

    func test_fetchTrending_onSuccess_decodesAndReturnsGifs() {
        // GIVEN
        network.dataTaskResultStub = .success(Response.trending.data)
        let expectedGifs = [Gif(id: "3ov9jCDL2WOP72ubQI",
                      type: "gif",
                      url: URL(string: "https://media3.giphy.com/media/3ov9jCDL2WOP72ubQI/200w.gif?cid=e1bb72ff19cc8af291f3cf4ab27f2fa1f74d5b5c7afa7ff8&rid=200w.gif")!,
                      videoURL: URL(string: "https://media3.giphy.com/media/3ov9jCDL2WOP72ubQI/giphy.mp4?cid=e1bb72ff19cc8af291f3cf4ab27f2fa1f74d5b5c7afa7ff8&rid=giphy.mp4")!
        )]

        var actualGifs = [Gif]()

        // WHEN
        subject.fetchTrending(offset: 0) { result in
            switch result {
            case .success(let gifs): actualGifs = gifs
            case .failure(_): XCTFail()
            }
        }

        // THEN
        XCTAssertEqual(expectedGifs, actualGifs)
    }

    func test_random_onSuccess_decodesAndReturnsGif() {
        // GIVEN
        network.dataTaskResultStub = .success(Response.random.data)
        let expectedGif = Gif(id: "61S8vuCYvHxLtFSDgh",
                      type: "gif",
                      url: URL(string: "https://media1.giphy.com/media/61S8vuCYvHxLtFSDgh/200w.gif?cid=e1bb72ffb57f0406326370245f4e735b70b74ba0f1c9b9df&rid=200w.gif")!,
                      videoURL: URL(string: "https://media1.giphy.com/media/61S8vuCYvHxLtFSDgh/giphy.mp4?cid=e1bb72ffb57f0406326370245f4e735b70b74ba0f1c9b9df&rid=giphy.mp4")!
        )

        var actualGif: Gif?

        // WHEN
        subject.fetchRandom { result in
            switch result {
            case .success(let gif): actualGif = gif
            case .failure(_): XCTFail()
            }
        }

        // THEN
        XCTAssertEqual(expectedGif, actualGif)
    }
}
