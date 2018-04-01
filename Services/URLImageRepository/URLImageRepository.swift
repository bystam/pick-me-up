//
//  Copyright © 2018 Frallware. All rights reserved.
//

import Foundation
import Frallware
import RxSwift

public protocol URLImageRepository {

    func imageURLs(forSubreddits subreddits: [String]) -> Observable<[URL]>

}

public class _URLImageRepository: URLImageRepository {

    private let client: NetworkClient

    public init(client: NetworkClient = StandardNetworkClient()) {
        self.client = client
    }

    public func imageURLs(forSubreddits subreddits: [String]) -> Observable<[URL]> {
        let client = self.client
        let subbredditObservables = subreddits.map(Observable.just)

        return Observable
            .merge(subbredditObservables)
            .map { ListingsCall(subreddit: $0, listing: .hot) }
            .flatMap { call in client.request(call).asSingle() }
            .map { response in
                return response.data.children.flatMap { child in
                    return child.data.preview?.images.map { $0.source.url } ?? []
                }
            }
            .reduce([URL](), accumulator: +)
    }
}

private extension ListingsCall.Child {


}
