import Foundation

struct GifResponse<D: Decodable>: Decodable {
    let value: D

    enum CodingKeys: String, CodingKey {
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(D.self, forKey: .data)
    }
}

struct Gif: Decodable, Equatable {
    let id: String
    let type: String
    let url: URL
    let videoURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case images
    }

    enum ImagesCodingKeys: String, CodingKey {
        case fixedWidth = "fixed_width"
        case original
        case url
        case mp4
    }
}

extension Gif {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        let images = try container
            .nestedContainer(keyedBy: ImagesCodingKeys.self, forKey: .images)
        url = try images
            .nestedContainer(keyedBy: ImagesCodingKeys.self, forKey: .fixedWidth)
            .decode(URL.self, forKey: .url)
        videoURL = try images
            .nestedContainer(keyedBy: ImagesCodingKeys.self, forKey: .original)
            .decode(URL.self, forKey: .mp4)
    }
}
