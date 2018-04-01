//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit
import Services
import Frallware
import RxSwift

final class MainViewModel {

    let feedEntries: Observable<[FeedEntry]> = {
        return Service.find(type: FeedRepository.self)
            .feedEntries(forSubreddits: [ "rarepuppers", "me_irl" ])
            .observeOn(MainScheduler.instance)
    }()
}
