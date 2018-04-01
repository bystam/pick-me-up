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
    private var entries: [FeedEntry] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        FeedEntryCell.registerAsNib(in: tableView)
        tableView.dataSource = self
        tableView.delegate = self

        listenToURLs()
    }

    private func listenToURLs() {
        model.feedEntries
            .subscribe(
                onNext: { [weak self] entries in
                    self?.entries = entries
                    self?.tableView.reloadData()
                },
                onError: { error in
                    print(error)
            })
            .disposed(by: bag)
    }
}

extension MainViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView
            .dequeueCell(type: FeedEntryCell.self, at: indexPath)
            .configure(entry: entries[indexPath.row])
    }
}

extension MainViewController: UITableViewDelegate {

}
