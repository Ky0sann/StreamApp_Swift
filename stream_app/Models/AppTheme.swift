//
//  AppTheme.swift
//  stream_app
//
//  Created by Cours on 05/02/2026.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    var title: String {
        switch self {
        case .system:
            return "Système"
        case .light:
            return "Clair"
        case .dark:
            return "Sombre"
        }
    }

    var icon: String {
        switch self {
        case .system:
            return "gearshape"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
}
