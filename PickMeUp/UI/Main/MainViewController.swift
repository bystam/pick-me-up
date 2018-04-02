//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit
import Frallware
import RxSwift
import Services

class MainViewController: UIViewController, StoryboardBased {

    static let storyboardName: String = "Main"

    private let model = MainViewModel()
    private let bag = DisposeBag()

    @IBOutlet private weak var pageView: PageView!
    private let page1 = UIView()
    private let page2 = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPages()
        listenToModelChanges()
    }

    private func setupPages() {
        page1.backgroundColor = .red
        page2.backgroundColor = .blue
        [page1, page2].forEach(pageView.addPage)

        pageView.currentPageAction = { [weak self] page in
            guard page > 0 else { return }
            self?.model.incrementPage()
            self?.pageView.scrollToPage(index: 0)
        }
    }

    private func listenToModelChanges() {
        model.page1Color.subscribe(onNext: { [weak self] color in
            self?.page1.backgroundColor = color
        }).disposed(by: bag)
        model.page2Color.subscribe(onNext: { [weak self] color in
            self?.page2.backgroundColor = color
        }).disposed(by: bag)
    }
}
