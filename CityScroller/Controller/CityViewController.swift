//
//  CityViewController.swift
//  CityScroller
//
//  Created by Tomasz Bogusz on 29.03.2018.
//  Copyright © 2018 Tomasz Bogusz. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
    private var grabOffset: CGVector?
    
    var scrollView: UIScrollView { return view as! UIScrollView }
    var moonView: MoonView?

    // MARK: - View Controller Lifecycle
    override func loadView() {
        self.view = UIScrollView()
        view.backgroundColor = UIColor.black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // TODO - move somewhere else?
        moonView = initMoonView()
        view.addSubview(moonView!)
    }

    // MARK: - Other functions
    private func initMoonView() -> MoonView {
        
        // Randomize MoonView
        let moonView = MoonView.randomMoon()
        // Set MoonView's origin
        let moonOriginX = CGFloat.random(min: 0, max: scrollView.bounds.width - moonView.bounds.width)
        let moonOriginY = CGFloat.random(min: 0, max: MoonView.maxStartingOriginY)
        moonView.frame.origin = CGPoint(x: moonOriginX, y: moonOriginY)
        // Setup LongPress gesture recognizer
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        moonView.addGestureRecognizer(longPress)
        
        return moonView
    }
    
    // MARK: - Gesture recognizer functions
    @objc func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
        guard let grabbedView = longPress.view else { return }
        let touchLocation = longPress.location(in: view)
        switch longPress.state {
        case .began:
            grab(view: grabbedView, up: true)
            grabOffset = CGVector(dx: touchLocation.x - grabbedView.center.x, dy: touchLocation.y - grabbedView.center.y)
        case .changed:
            let grabOffset = self.grabOffset ?? CGVector.zero
            grabbedView.center = CGPoint(x: touchLocation.x - grabOffset.dx, y: touchLocation.y - grabOffset.dy)
        case .cancelled:
            fallthrough
        case .ended:
            grab(view: grabbedView, up: false)
            grabOffset = nil
        default:
            return
        }
    }
    
    private func grab(view: UIView, up: Bool) {
        let animator = UIViewPropertyAnimator(duration: 0.15, curve: .linear) {
            view.transform = up ? CGAffineTransform(scaleX: 1.2, y: 1.2) : CGAffineTransform.identity
            view.alpha = up ? 0.7 : 1.0
        }
        //self.view.bringSubview(toFront: view)
        animator.startAnimation()
    }
}

