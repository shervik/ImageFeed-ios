//
//  GradientView.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 04.01.2023.
//

import UIKit

final class GradientView: UIView {
    let gradientLayer = CAGradientLayer()

    func getGradientForAnimation(frame: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        layer.locations = [0, 0.1, 0.3]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.frame = frame
        layer.cornerRadius = 35
        layer.masksToBounds = true
        return layer
    }

    func addAnimation(for layer: CAGradientLayer) {
        var animationLayers = Set<CALayer>()
        animationLayers.insert(layer)
        setAnimate(for: layer)
    }

    private func setAnimate(for layer: CAGradientLayer) {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.autoreverses = true
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        layer.add(gradientChangeAnimation, forKey: "locationsChange")
    }
}
