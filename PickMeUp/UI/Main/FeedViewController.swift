//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit
import Frallware
import RxSwift
import Services
import SDWebImage

class FeedViewController: UIViewController, StoryboardBased {

    static let storyboardName: String = "Feed"

    private let model = FeedViewModel()
    private let bag = DisposeBag()

    @IBOutlet private weak var pageView: PageView!
    private let currentPage = UIImageView()
    private let nextPage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPages()
        listenToModelChanges()
    }

    private func setupPages() {
        currentPage.contentMode = .scaleAspectFit
        nextPage.contentMode = .scaleAspectFit
        [currentPage, nextPage].forEach(pageView.addPage)

        pageView.currentPageAction = { [weak self] page in
            guard page > 0 else { return }
            self?.model.incrementPage()
        }
    }

    private func listenToModelChanges() {
        model.feedEntryPair.subscribe(onNext: { [weak self] pair in
            self?.currentPage.sd_setImage(with: pair.current.image.url)
            self?.nextPage.sd_setImage(with: pair.next.image.url)
            self?.pageView.scrollToPage(index: 0)
        }).disposed(by: bag)
    }
}
