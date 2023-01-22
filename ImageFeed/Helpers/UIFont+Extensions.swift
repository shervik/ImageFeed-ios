//
//  UIFont+Extensions.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 13.01.2023.
//

import UIKit

extension UIFont {
    static let sfDisplayBold = UIFont(name: "SFProDisplay-Bold", size: 23) ??
    UIFont.systemFont(ofSize: 23, weight: Weight(700))
    static let sfDisplayMedium = UIFont(name: "SFProDisplay-Medium", size: 13) ??
    UIFont.systemFont(ofSize: 13, weight: Weight(500))
    static let sfDisplayRegular = UIFont(name: "SFProDisplay-Regular", size: 13) ??
    UIFont.systemFont(ofSize: 13, weight: Weight(400))
    static let sfDisplaySemibold = UIFont(name: "SFProDisplay-Semibold", size: 13) ??
    UIFont.systemFont(ofSize: 13, weight: Weight(600))
}
