//
//  InfiniteScrollView.swift
//  CityScroller
//
//  Created by Tomasz Bogusz on 29.03.2018.
//  Copyright © 2018 Tomasz Bogusz. All rights reserved.
//

import UIKit

class InfiniteScrollView: UIScrollView {
    
    private let buildingsContainerView = UIView()
    private let moonView = MoonView.randomMoon()
    
    // MARK: - Instance properties
    override var frame: CGRect {
        didSet {
            setup(size: bounds.size)
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(buildingsContainerView)
        addSubview(moonView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Functions
    func setup(size: CGSize) {
        contentSize = CGSize(width: size.width * 3, height: size.height)
        buildingsContainerView.frame = CGRect(origin: .zero, size: contentSize)
        // TMP Settings for debuggig
        backgroundColor = .black
        indicatorStyle = .white
        
        contentOffset.x = (contentSize.width - bounds.width) / 2.0
        
        // Set MoonView's origin
        let moonOriginXOffset = CGFloat.random(min: 0, max: bounds.width - moonView.bounds.width)
        let moonOriginYOffset = CGFloat.random(min: 0, max: MoonView.maxStartingOriginY)
        moonView.frame.origin = CGPoint(x: contentOffset.x + moonOriginXOffset, y: moonOriginYOffset)
    }
    
    func positionMoon() {
        //moonView.frame.origin
    }

}
