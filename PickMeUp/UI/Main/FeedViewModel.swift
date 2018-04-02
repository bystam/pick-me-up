//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit
import Services
import Frallware
import RxSwift

final class FeedViewModel {

    struct FeedEntryPair {
        let current: FeedEntry
        let next: FeedEntry
    }

    private let currentIndex = BehaviorSubject<Int>(value: 0)

    let feedEntryPair: Observable<FeedEntryPair>

    init() {

        let repository = Service.find(type: FeedRepository.self)
        let remoteEntries = repository.feedEntries(forSubreddits: ["rarepuppers"])

        feedEntryPair = Observable.combineLatest(remoteEntries, currentIndex, resultSelector: { (entries, index) -> FeedEntryPair in
                let current = entries[index]
                let next = entries[index + 1]
                return FeedEntryPair(current: current, next: next)
            })
            .observeOn(MainScheduler.instance)
    }
}

extension FeedViewModel {

    func incrementPage() {
        let current = (try? currentIndex.value()) ?? 0
        currentIndex.onNext(current + 1)
    }
}
