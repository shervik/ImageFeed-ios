//
//  UILabel+Extensions.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 16.01.2023.
//

import UIKit

extension UILabel {
    func addCharactersSpacing(_ spacing: CGFloat) {
        let attributes: NSDictionary = [NSAttributedString.Key.kern:CGFloat(spacing)]
        let attributedTitle = NSAttributedString(string: self.text ?? "", attributes: attributes as? [NSAttributedString.Key : Any])
        self.attributedText = attributedTitle
    }
}
