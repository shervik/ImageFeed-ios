//
//  CAGradientLayer+Extensions.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 29.12.2022.
//

import Foundation
import UIKit

extension CAGradientLayer {
    static func createGradientLayer(frame: CGRect) -> Self {
        let layer = Self()
        layer.type = .axial
        layer.colors = setGrafientLabelColors()
        layer.frame = frame
        return layer
    }

    private static func setGrafientLabelColors() -> [CGColor] {
        let beginColor: UIColor = .ypBlack.withAlphaComponent(0)
        let endColor: UIColor = .ypBlack.withAlphaComponent(1)

        return [beginColor.cgColor, endColor.cgColor]
    }
}
