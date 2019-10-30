@testable import Figgy
import Foundation

final class MockNetwork: Network {

    var dataTaskCalledURL = URL(string: "dataTask")!
    var dataTaskCalled = false
    var dataTaskStub = MockNetworkTask()
    var dataTaskResultStub: Result<Data, RequestError>?
    func dataTask(with url: URL,
                  completion: @escaping (Result<Data, RequestError>) -> Void) -> NetworkTask {
        dataTaskCalled = true
        dataTaskCalledURL = url
        dataTaskResultStub.map(completion)

        return dataTaskStub
    }
}

final class MockNetworkTask: NetworkTask {
    var resumeCalled = false
    func resume() {
        resumeCalled = true
    }

    var cancelCalled = false
    func cancel() {
        cancelCalled = true
    }
}
