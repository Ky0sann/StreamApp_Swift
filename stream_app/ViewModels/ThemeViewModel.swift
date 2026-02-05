//
//  ThemeViewModel.swift
//  stream_app
//
//  Created by Cours on 05/02/2026.
//

import SwiftUI

final class ThemeViewModel: ObservableObject {

    @AppStorage("appTheme") private var storedTheme: String = AppTheme.system.rawValue

    @Published var currentTheme: AppTheme = .system {
        didSet {
            storedTheme = currentTheme.rawValue
        }
    }

    init() {
        currentTheme = AppTheme(rawValue: storedTheme) ?? .system
    }
}
