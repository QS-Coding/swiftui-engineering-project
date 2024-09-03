//
//  DateExtension.swift
//  MobileAcebook
//
//  Created by Sam Quincey on 03/09/2024.
//

import Foundation

extension Date {
    func iso8601String() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
}
