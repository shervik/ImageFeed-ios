//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 29.12.2022.
//

import Foundation

extension Date {

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    func dateFormatter(dateInString: String) -> Date {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: dateInString) ?? Date()
    }
}
