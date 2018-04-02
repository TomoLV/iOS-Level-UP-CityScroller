//
//  InfiniteScrollView.swift
//  CityScroller
//
//  Created by Tomasz Bogusz on 29.03.2018.
//  Copyright © 2018 Tomasz Bogusz. All rights reserved.
//

import UIKit

class InfiniteScrollView: UIScrollView {
    
    // MARK: - Instance properties
    private let buildingsContainerView = UIView()
    private var visibleBuildings: [BuildingView] = []
    
    override var frame: CGRect {
        didSet {
            setup(size: bounds.size)
        }
    }
    
    // MARK: View's Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        recenterIfNecessary()
        let visibleBounds = convert(bounds, to: buildingsContainerView)
        tileBuildings(from: visibleBounds.minX, to: visibleBounds.maxX)
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(buildingsContainerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Functions
    func setup(size: CGSize) {
        contentSize = CGSize(width: size.width * 3, height: BuildingView.maxBuildingHeight)
        buildingsContainerView.frame = CGRect(origin: .zero, size: contentSize)
        buildingsContainerView.backgroundColor = .clear
        // Pass all touches, so moonView can be moved
        buildingsContainerView.isUserInteractionEnabled = false
        backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        visibleBuildings.forEach { $0.removeFromSuperview() }
        visibleBuildings.removeAll()
        contentOffset.x = (contentSize.width - bounds.width) / 2.0
    }
    
    private func placeNewBuildingOnTheRight(edge: CGFloat) -> BuildingView {
        let building = BuildingView.randomBuilding()
        building.frame.origin.x = edge
        building.frame.origin.y = buildingsContainerView.bounds.height - building.bounds.height
        visibleBuildings.append(building)
        buildingsContainerView.addSubview(building)
        return building
    }
    
    private func placeNewBuildingOnTheLeft(edge: CGFloat) -> BuildingView {
        let building = BuildingView.randomBuilding()
        building.frame.origin.x = edge - building.frame.width
        building.frame.origin.y = buildingsContainerView.bounds.height - building.bounds.height
        visibleBuildings.insert(building, at: 0)
        buildingsContainerView.addSubview(building)
        return building
    }
    
    private func recenterIfNecessary() {
        let currentOffset = contentOffset
        let contentWidth = contentSize.width
        let centerOffsetX = (contentWidth - bounds.width) / 2.0
        let distanceFromCenter = fabs(currentOffset.x - centerOffsetX)
        
        if distanceFromCenter >= bounds.width {
            contentOffset.x = centerOffsetX
            for building in visibleBuildings {
                var center = buildingsContainerView.convert(building.center, to: self)
                center.x += centerOffsetX - currentOffset.x
                building.center = convert(center, to: buildingsContainerView)
            }
        }
    }
    
    private func tileBuildings(from minX: CGFloat, to maxX: CGFloat) {
        if visibleBuildings.count == 0 { _ = placeNewBuildingOnTheRight(edge: minX) }
        
        var lastVisibleBuilding = visibleBuildings.last!
        while lastVisibleBuilding.frame.maxX < maxX {
            lastVisibleBuilding = placeNewBuildingOnTheRight(edge: lastVisibleBuilding.frame.maxX)
        }
        
        var firstVisibleBuilding = visibleBuildings.first!
        while firstVisibleBuilding.frame.minX > minX {
            firstVisibleBuilding = placeNewBuildingOnTheLeft(edge: firstVisibleBuilding.frame.minX)
        }
        
        for (index, building) in visibleBuildings.enumerated() {
            if building.frame.maxX <= minX || building.frame.minX >= maxX {
                visibleBuildings.remove(at: index)
                building.removeFromSuperview()
            }
        }
    }

}
