//
//  CityViewController.swift
//  CityScroller
//
//  Created by Tomasz Bogusz on 29.03.2018.
//  Copyright © 2018 Tomasz Bogusz. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
    // MARK: - Instance properties
    
    private var grabOffset: CGVector?
    private var moonViewCenterOffset: CGPoint? // TODO: - Could potentially change it to implicitly unwrapped optional for easier use in the code
    private var scrollView: InfiniteScrollView { return view as! InfiniteScrollView }
    private var moonView = MoonView.randomMoon()
    private let moonViewParallaxMultiplier: CGFloat = 0.5
    
    private var lastContentOffsetY: CGFloat?
    
    // MARK: - View Controller's Lifecycle
    
    override func loadView() {
        self.view = InfiniteScrollView()
        view.backgroundColor = UIColor.black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        moonView.addGestureRecognizer(longPress)
        
        view.addSubview(moonView)
        view.sendSubview(toBack: moonView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        randomizeMoonViewOffsetIfNecessary()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        scrollView.setup(size: size)
        if moonViewCenterOffset != nil {
            moonViewCenterOffset!.x = moonViewCenterOffset!.x * size.width / view.frame.width
            moonViewCenterOffset!.y = moonViewCenterOffset!.y * size.height / view.frame.height
        }
    }
    
    // MARK: - Other functions
    
    private func positionMoonView() {
        guard let moonViewCenterOffset = moonViewCenterOffset else { return }
        moonView.center.x = scrollView.contentOffset.x + moonViewCenterOffset.x
        // Support parallax moonView
        moonView.center.y = scrollView.contentOffset.y * moonViewParallaxMultiplier + moonViewCenterOffset.y
    }
    
    private func randomizeMoonViewOffsetIfNecessary() {
        guard moonViewCenterOffset == nil else { return }
        let offsetX = CGFloat.random(min: moonView.bounds.width / 2, max: view.bounds.width - moonView.bounds.width / 2)
        let offsetY = CGFloat.random(min: moonView.bounds.height / 2, max: MoonView.maxStartingCenterY)
        moonViewCenterOffset = CGPoint(x: offsetX, y: offsetY)
        positionMoonView()
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
            let centerX = touchLocation.x - grabOffset.dx
            // moonView should stay in the upper part of the parent view
            let centerY = touchLocation.y - grabOffset.dy <= MoonView.maxMoveCenterY + scrollView.contentOffset.y * moonViewParallaxMultiplier ? touchLocation.y - grabOffset.dy : grabbedView.center.y
            grabbedView.center = CGPoint(x: centerX, y: centerY)
        case .cancelled:
            fallthrough
        case .ended:
            grab(view: grabbedView, up: false)
            grabOffset = nil
            // Support parallax moonView
            moonViewCenterOffset = CGPoint(x: grabbedView.center.x - scrollView.contentOffset.x, y: grabbedView.center.y - scrollView.contentOffset.y * moonViewParallaxMultiplier)
        default:
            return
        }
    }
    
    private func grab(view: UIView, up: Bool) {
        let animator = UIViewPropertyAnimator(duration: 0.15, curve: .linear) {
            view.transform = up ? CGAffineTransform(scaleX: 1.2, y: 1.2) : CGAffineTransform.identity
            view.alpha = up ? 0.7 : 1.0
        }
        animator.startAnimation()
    }
}

// MARK: - UIScrollViewDelegate implementation

extension CityViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        positionMoonView()
    }
}

