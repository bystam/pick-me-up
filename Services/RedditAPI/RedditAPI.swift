//
//  Copyright © 2018 Frallware. All rights reserved.
//

import Foundation
import Frallware


public struct ListingsCall: NetworkCall, VoidRequestBodied, JSONResponseBodied {

    public enum Listing: String {
        case hot
        case new
    }

    public struct ResponseBody: Decodable {
        let data: ListingData
    }

    public let method: HTTPMethod = .get
    public let url: URL

    public init(subreddit: String, listing: Listing) {
        self.url = listing.url(subreddit: subreddit)
    }
}

public extension ListingsCall {

    public struct ListingData: Decodable {
        let children: [Child]
    }

    public struct Child: Decodable {
        let data: ChildData
    }

    public struct ChildData: Decodable {
        let title: String
        let preview: Preview?
    }

    public struct Preview: Decodable {
        let images: [ImageData]
    }

    public struct ImageData: Decodable {
        let source: Image
        let resolutions: [Image]
    }

    public struct Image: Decodable {
        let url: URL
        let width: Int
        let height: Int
    }
}

private extension ListingsCall.Listing {

    func url(subreddit: String) -> URL {
        return URL(string: "https://api.reddit.com/r/\(subreddit)/\(rawValue)?raw_json=1")!
    }
}
