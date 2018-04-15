//
//  Copyright © 2018 Frallware. All rights reserved.
//

import Foundation
import Frallware
import RxSwift
import CoreGraphics

public protocol FeedRepository {

    func feedEntries(forSubreddits subreddits: [String]) -> Observable<[FeedEntry]>

}

public class _FeedRepository: FeedRepository {

    private let client: NetworkClient

    public init(client: NetworkClient) {
        self.client = client
    }

    public func feedEntries(forSubreddits subreddits: [String]) -> Observable<[FeedEntry]> {
        let client = self.client
        let subredditObservables = subreddits.map(Observable.just)

        return Observable
            .merge(subredditObservables)
            .map { ListingsCall(subreddit: $0, listing: .hot) }
            .flatMap { call in client.request(call).asSingle() }
            .map { response in
                return response.body.data.children.compactMap(FeedEntry.init)
            }
            .reduce([FeedEntry](), accumulator: +)
    }
}

private extension FeedEntry {

    init?(apiChild: ListingsCall.Child) {
        guard let apiImage = apiChild.data.preview?.images.first?.source else {
            return nil
        }

        let image = FeedImage(size: CGSize(width: apiImage.width, height: apiImage.height),
                              url: apiImage.url)
        self = FeedEntry(title: apiChild.data.title, image: image)
    }
}
