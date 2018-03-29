//
//  MoonView.swift
//  CityScroller
//
//  Created by Tomasz Bogusz on 29.03.2018.
//  Copyright © 2018 Tomasz Bogusz. All rights reserved.
//

import UIKit

class MoonView: UIView {
    
    class func randomMoon() -> MoonView {
        let size = CGFloat.random(min: minMoonHeight, max: maxMoonHeight)
        let brightness = MoonBrightness.random
        
        return MoonView(size: size, brightness: brightness)
    }
    
    class var minMoonHeight: CGFloat {
        return UIScreen.main.bounds.height * Constants.minMoonHeightMultiplier
    }
    
    class var maxMoonHeight: CGFloat {
        return UIScreen.main.bounds.height * Constants.maxMoonHeightMultiplier
    }
    
    private enum MoonBrightness: RandomizableRange {
        case light
        case medium
        case bright
        
        static var all: [MoonBrightness] { return [.light, .medium, .bright] }
    }
    
    private let size: CGSize
    private let brightness: MoonBrightness

    private init(size: CGFloat, brightness: MoonBrightness) {
        
        self.size = CGSize(width: size, height: size)
        self.brightness = brightness
        
        super.init(frame: CGRect(origin: .zero, size: self.size))
        
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
