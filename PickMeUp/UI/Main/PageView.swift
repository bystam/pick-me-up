//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit

final class PageView: UIView {

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.bounces = false
        return sv
    }()

    private var pageViews: [UIView] = []

    var currentPageAction: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        scrollView.delegate = self
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        pageViews.enumerated().forEach { (index, pageView) in
            var pageViewFrame = scrollView.bounds
            pageViewFrame.origin.x += CGFloat(index) * pageViewFrame.width
            pageView.frame = pageViewFrame
        }

        var contentSize = scrollView.bounds.size
        contentSize.width *= CGFloat(pageViews.count)
        scrollView.contentSize = contentSize
    }

    func addPage(_ view: UIView) {
        scrollView.addSubview(view)
        pageViews.append(view)
    }

    func scrollToPage(index: Int) {
        let offset = CGFloat(index) * scrollView.bounds.width
        scrollView.contentOffset.x = offset
    }
}

extension PageView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x))
        currentPageAction?(page)
    }
}
