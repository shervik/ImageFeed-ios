//
//  UIView+Extension.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 15.03.2023.
//

import UIKit

extension UIView {
    func addGradient(with layer: CAGradientLayer, gradientFrame: CGRect? = nil, colorSet: [UIColor],
                     locations: [Double], startEndPoints: (CGPoint, CGPoint)? = nil) {
        layer.frame = gradientFrame ?? self.bounds
        layer.frame.origin = .zero

        let layerColorSet = colorSet.map { $0.cgColor }
        layer.colors = layerColorSet

        let layerLocations = locations.map { $0 as NSNumber }
        layer.locations = layerLocations

        if let startEndPoints = startEndPoints {
            layer.startPoint = startEndPoints.0
            layer.endPoint = startEndPoints.1
        }

        self.layer.addSublayer(layer)
    }
}
