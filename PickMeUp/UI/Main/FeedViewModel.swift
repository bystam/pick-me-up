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

        let remoteFetchTrigger = PublishSubject<Void>()

        let localEntries = BehaviorSubject<[FeedEntry]>(value: [])
        self.localEntries = localEntries

        let repository = Service.find(type: FeedRepository.self)
        let remoteEntries = Observable.concat(Observable.just(()), remoteFetchTrigger)
            .flatMap { _ in repository.feedEntries(forSubreddits: ["rarepuppers"]) }
            .do(onNext: localEntries.append)

        let totalEntries = Observable.combineLatest(localEntries, remoteEntries, resultSelector: { (local, _) -> [FeedEntry] in
                return local
            })
            .do(onNext: { local in
                if local.count <= 2 {
                    remoteFetchTrigger.onNext(())
                }
            })
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
