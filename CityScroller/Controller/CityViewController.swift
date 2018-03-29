//
//  CityViewController.swift
//  CityScroller
//
//  Created by Tomasz Bogusz on 29.03.2018.
//  Copyright © 2018 Tomasz Bogusz. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
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
        moonView = setupMoonView()
        view.addSubview(moonView!)
    }

    // MARK: - Other functions
    private func setupMoonView() -> MoonView {
        
        // Randomize MoonView
        let moonView = MoonView.randomMoon()
        // Set MoonView's origin
        let moonOriginX = CGFloat.random(min: 0, max: view.bounds.width - moonView.bounds.width)
        let moonOriginY = CGFloat.random(min: 0, max: Constants.maxMoonStartingOriginY)
        moonView.frame.origin = CGPoint(x: moonOriginX, y: moonOriginY)
        // Setup LongPress gesture recognizer
        
        return moonView
    }
    
    // MARK: - Gesture recognizer functions
}

