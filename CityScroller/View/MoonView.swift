//
//  MoonView.swift
//  CityScroller
//
//  Created by Tomasz Bogusz on 29.03.2018.
//  Copyright © 2018 Tomasz Bogusz. All rights reserved.
//

import UIKit

class MoonView: UIView {
    
    // MARK: - Class functions
    class func randomMoon() -> MoonView {
        let size = CGFloat.random(min: minMoonHeight, max: maxMoonHeight)
        let brightness = MoonBrightness.random
        
        return MoonView(size: size, brightness: brightness)
    }
    
    // MARK: - Class properties
    class var minMoonHeight: CGFloat {
        return UIScreen.main.bounds.height * MoonViewConstants.minHeightMultiplier
    }
    class var maxMoonHeight: CGFloat {
        return UIScreen.main.bounds.height * MoonViewConstants.maxHeightMultiplier
    }
    class var maxStartingOriginY: CGFloat {
        return UIScreen.main.bounds.height * MoonViewConstants.maxStartingOriginYMultiplier
    }
    class var maxMoveOriginY: CGFloat {
        return UIScreen.main.bounds.height * MoonViewConstants.maxMoveOriginYMultiplier
    }
    
    // MARK: - Private types
    private enum MoonBrightness: RandomizableRange {
        case light
        case medium
        case bright
        
        static var all: [MoonBrightness] { return [.light, .medium, .bright] }
    }
    
    private struct MoonViewConstants {
        static let minHeightMultiplier: CGFloat = 0.1
        static let maxHeightMultiplier: CGFloat = 0.2
        static let maxStartingOriginYMultiplier: CGFloat = 0.1
        static let maxMoveOriginYMultiplier: CGFloat = 0.3
    }
    
    // MARK: - Instance properties
    private let size: CGSize
    private let brightness: MoonBrightness

    // MARK: - Initializers
    private init(size: CGFloat, brightness: MoonBrightness) {
        
        self.size = CGSize(width: size, height: size)
        self.brightness = brightness
        
        super.init(frame: CGRect(origin: .zero, size: self.size))
        
        layer.cornerRadius = size * 0.5
        switch brightness {
        case .light:
            backgroundColor = #colorLiteral(red: 0.9689160439, green: 0.9995340705, blue: 0.6887885741, alpha: 1)
        case .medium:
            backgroundColor = #colorLiteral(red: 0.9507429377, green: 0.9995340705, blue: 0.4629764804, alpha: 1)
        case .bright:
            backgroundColor = #colorLiteral(red: 0.9768924427, green: 0.9995340705, blue: 0.08164246027, alpha: 1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
