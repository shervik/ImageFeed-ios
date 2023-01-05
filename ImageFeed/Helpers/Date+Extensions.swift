//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 29.12.2022.
//

import Foundation

extension Date {
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
