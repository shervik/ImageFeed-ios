//
//  GradientView.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 04.01.2023.
//

import UIKit

final class GradientView: UIView {
    let beginColor: UIColor = .ypBlack.withAlphaComponent(0)
    let endColor: UIColor = .ypBlack.withAlphaComponent(1)
    let vertical: Bool = true

    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [beginColor.cgColor, endColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    func applyGradient() {
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
        layer.sublayers = [gradientLayer]
    }
}
