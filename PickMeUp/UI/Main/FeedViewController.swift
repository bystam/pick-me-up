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
    private let currentImageView = UIImageView()
    private let nextImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPages()
        listenToModelChanges()
    }

    private func setupPages() {
        currentImageView.contentMode = .scaleAspectFit
        nextImageView.contentMode = .scaleAspectFit

        var constraints: [NSLayoutConstraint] = []
        zip([pageView.firstView, pageView.secondView], [currentImageView, nextImageView]).forEach { (container, view) in
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(contentsOf: NSLayoutConstraint.fill(view, inside: container))
        }
        NSLayoutConstraint.activate(constraints)

        pageView.pageChangeAction = { [weak self] in
            self?.model.nextPage()
        }
    }

    private func listenToModelChanges() {
        model.currentEntry.subscribe(onNext: { [weak self] entry in
            self?.currentImageView.sd_setImage(with: entry.image.url)
        }).disposed(by: bag)
        model.nextEntry.subscribe(onNext: { [weak self] entry in
            self?.nextImageView.sd_setImage(with: entry.image.url)
        }).disposed(by: bag)
    }
}
