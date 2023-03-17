//
//  DateFormatter+Extensions.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 29.12.2022.
//

import Foundation

extension DateFormatter {

    static let isoDateFormatter = ISO8601DateFormatter()

    static let longDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none

        return formatter
    }()
}
