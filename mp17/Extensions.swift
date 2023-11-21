//
//  Extensions.swift
//  mp17
//
//  Created by Andrew Us on 21.11.23.
//

import SwiftUI

public extension Color {
    static var lightGray: Color { Color.white.opacity(0.6) }
    static var fadeGray: Color { Color.white.opacity(0.3) }
}

extension Double {
    func formatMmSs() -> String {
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
