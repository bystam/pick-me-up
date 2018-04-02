//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit
import Services
import Frallware
import RxSwift

final class FeedViewModel {

    private let localEntries: BehaviorSubject<[FeedEntry]>

    let currentEntry: Observable<FeedEntry>
    let nextEntry: Observable<FeedEntry>

    init() {

        let localEntries = BehaviorSubject<[FeedEntry]>(value: [])
        self.localEntries = localEntries

        // trigger once first, then every time there's only 2 left
        let remoteFetchTrigger = localEntries
            .filter { $0.count == 2 }
            .map { _ in () }
            .startWith(())

        // fetch new entries, cache in localEntries
        // but never emit, since it would be duplicate a from localEntries
        let repository = Service.find(type: FeedRepository.self)
        let remoteEntries = remoteFetchTrigger
            .flatMap { _ in repository.feedEntries(forSubreddits: ["rarepuppers"]) }
            .do(onNext: localEntries.append)
            .filter { _ in false }

        // only use localEntries, but make sure remoteEntries are subscribed to
        let totalEntries = Observable.merge(localEntries, remoteEntries)
            .share(replay: 1)
            .observeOn(MainScheduler.instance)

        currentEntry = totalEntries
            .filter { $0.count >= 1 }
            .map { $0[0] }
        nextEntry = totalEntries
            .filter { $0.count >= 2 }
            .map { $0[1] }
    }
}

extension FeedViewModel {

    func nextPage() {
        localEntries.removeFirst()
    }
}

private extension BehaviorSubject where Element == [FeedEntry] {

    func removeFirst() {
        var entries = (try? value()) ?? []
        entries.removeFirst()
        onNext(entries)
    }

    func append(_ otherEntries: [FeedEntry]) {
        var entries = (try? value()) ?? []
        entries.append(contentsOf: otherEntries)
        onNext(entries)
    }
}
