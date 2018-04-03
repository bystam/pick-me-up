//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit
import Frallware

final class PageView: UIView {

    let firstView = UIView()
    let secondView = UIView()

    private lazy var pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))

    var pageChangeAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addGestureRecognizer(pan)

        [firstView, secondView].forEach { view in
            view.clipsToBounds = true
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: centerXAnchor),
                view.centerYAnchor.constraint(equalTo: centerYAnchor),
                view.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1.0),
                view.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 1.0),
            ])
        }

        secondView.isHidden = true
    }


    @objc private func didPan(_ pan: UIPanGestureRecognizer) {

        let shortestSideLength = min(firstView.bounds.width, firstView.bounds.height)
        let largestCornerRadius = shortestSideLength / 2

        let translation = pan.translation(in: self)
        let transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        let translationDistance = sqrt(translation.x * translation.x + translation.y * translation.y)

        switch pan.state {

        case .began, .possible:

            break

        case .changed:
            firstView.layer.cornerRadius = min(1.5 * translationDistance, largestCornerRadius)

            firstView.transform = transform

        case .ended, .cancelled, .failed:

            performTransition(withVelocity: pan.velocity(in: self))
        }
    }

    private func performTransition(withVelocity velocity: CGPoint) {
        let diff = 0.4 * velocity
//        let firstViewEndPoint = center + diff
//        let secondViewStartPoint = center - diff

        let velocityParam = CGVector(dx: velocity.x, dy: velocity.y).normalized()
        let parameters = UISpringTimingParameters(dampingRatio: 1.0, initialVelocity: velocityParam)
        let animator = UIViewPropertyAnimator(duration: 0.3, timingParameters: parameters)

        secondView.isHidden = false
        secondView.transform = CGAffineTransform(translationX: -diff.x, y: -diff.y)
        pan.isEnabled = false

        animator.addAnimations {
            self.firstView.layer.cornerRadius = 0
            self.firstView.transform = CGAffineTransform(translationX: diff.x, y: diff.y)
            self.secondView.transform = .identity
        }

        animator.addCompletion { position in
            self.firstView.transform = .identity
            self.secondView.isHidden = true

            self.pan.isEnabled = true
            self.pageChangeAction?()
        }

        animator.startAnimation()
    }
}
