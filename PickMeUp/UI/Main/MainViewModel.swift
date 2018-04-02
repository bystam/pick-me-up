//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit
import Services
import Frallware
import RxSwift

final class MainViewModel {

    private let currentIndex = BehaviorSubject<Int>(value: 0)

    let page1Color: Observable<UIColor>
    let page2Color: Observable<UIColor>

    init() {
        page1Color = currentIndex.map { index -> UIColor in
            let isOdd = (index & 1) == 1
            return isOdd ? .red : .blue
        }
        page2Color = currentIndex.map { index -> UIColor in
            let isOdd = (index & 1) == 1
            return isOdd ? .blue : .red
        }
    }
}

extension MainViewModel {

    func incrementPage() {
        let current = (try? currentIndex.value()) ?? 0
        currentIndex.onNext(current + 1)
    }

}
