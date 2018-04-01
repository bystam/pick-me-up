//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit
import Frallware
import RxSwift

class MainViewController: UIViewController, StoryboardBased {

    static let storyboardName: String = "Main"
    @IBOutlet weak var label: UILabel!

    private let model = MainViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        listenToURLs()
    }

    private func listenToURLs() {
        model.images
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] urls in
                    self?.label.text = urls.map { $0.absoluteString }.joined(separator: "\n")
                },
                onError: { error in
                    print(error)
            })
            .disposed(by: bag)
    }
}

