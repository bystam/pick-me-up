//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit
import Services
import Frallware
import RxSwift

final class FeedViewModel {

    private let localEntries: BehaviorSubject<[FeedEntry]>

    let currentEntry: Observable<FeedEntry?>
    let nextEntry: Observable<FeedEntry?>

    init() {

        let localEntries = BehaviorSubject<[FeedEntry]>(value: [])
        self.localEntries = localEntries

        // trigger once first, then every time there's only 2 left
        let remoteFetchTrigger = localEntries
            .filter { $0.count == 2 }
            .map { _ in () }
            .startWith(())

        // fetch new entries, cache in localEntries, but never emit
        let repository = Service.find(type: FeedRepository.self)
        let remoteEntries = remoteFetchTrigger
            .flatMap { _ in repository.feedEntries(forSubreddits: ["rarepuppers"]) }
            .do(onNext: localEntries.append)
            .filter { _ in false }

        // only use localEntries, but make sure remoteEntries are subscribed to
        let totalEntries = Observable.merge(localEntries, remoteEntries)
            .share(replay: 1)
            .observeOn(MainScheduler.instance)

        currentEntry = totalEntries.map { entries in
            return entries.first
        }
        nextEntry = totalEntries.map { entries in
            guard entries.count >= 2 else { return nil }
            return entries[1]
        }
    }
}

extension FeedViewModel {

    func incrementPage() {
        self.localEntries.removeFirst()
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
