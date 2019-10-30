import Foundation

enum Response {
    case trending
    case random

    var data: Data {
        return try! Bundle(for: MockNetwork.self)
            .url(forResource: name, withExtension: "json")
            .flatMap { try Data(contentsOf: $0) } ?? Data()
    }

    var name: String {
        switch self {
        case .random: return "RandomResponse"
        case .trending: return "TrendingResponse"
        }
    }
}
