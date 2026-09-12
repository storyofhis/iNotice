//
//  Color+Opal.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 12/09/26.
//

import SwiftUI

extension Color {
    static let opalBackground = Color(hex: 0x121212)
    static let opalSurface = Color(hex: 0x1E1E1E)
    static let opalTextPrimary = Color(hex: 0xEDEDED)
    static let opalTextSecondary = Color(hex: 0x9A9A9A)

    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}

enum CategoryColor: String, CaseIterable, Codable, Hashable {
    case dustyRose, mutedTeal, deepAmber, slateBlue

    var color: Color {
        switch self {
        case .dustyRose: Color(hex: 0xC97B84)
        case .mutedTeal: Color(hex: 0x4E7C74)
        case .deepAmber: Color(hex: 0xB8895A)
        case .slateBlue: Color(hex: 0x5C7A99)
        }
    }
}
