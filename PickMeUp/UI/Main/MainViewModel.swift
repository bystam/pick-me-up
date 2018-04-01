//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit
import Services
import Frallware
import RxSwift

final class MainViewModel {

    let feedEntries: Observable<[FeedEntry]>


    init() {
        let repository = Service.find(type: FeedRepository.self)
        self.feedEntries = repository
            .feedEntries(forSubreddits: [ "rarepuppers", "me_irl" ])
    }

}
