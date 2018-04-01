//
//  Copyright © 2018 Frallware. All rights reserved.
//

import Foundation
import Services
import Frallware
import RxSwift

final class MainViewModel {

    let images: Observable<[URL]>

    init() {
        let repository = Service.find(type: URLImageRepository.self)
        self.images = repository
            .imageURLs(forSubreddits: [ "rarepuppers", "me_irl" ])
            .map { urls in Array(urls.prefix(4)) }
    }

}
