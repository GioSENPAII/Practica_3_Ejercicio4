//
//  ThemeManager.swift
//  GestorArchivosIPN
//
//  Created by Giovanni Javier Longoria Bunoust on 17/04/25.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case ipn = "IPN"
    case escom = "ESCOM"
    
    var id: String { self.rawValue }
    
    var primaryColor: Color {
        switch self {
        case .ipn:
            return Color(red: 0.53, green: 0.0, blue: 0.21) // Vino IPN (#880035)
        case .escom:
            return Color(red: 0.0, green: 0.31, blue: 0.63) // Azul ESCOM (#0050A0)
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .ipn:
            return Color(red: 0.76, green: 0.55, blue: 0.0) // Dorado IPN (#C28C00)
        case .escom:
            return Color(red: 0.55, green: 0.55, blue: 0.55) // Gris ESCOM (#8C8C8C)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .ipn, .escom:
            return Color(.systemBackground) // Se adapta automáticamente al modo claro/oscuro
        }
    }
    
    var textColor: Color {
        switch self {
        case .ipn, .escom:
            return Color(.label) // Se adapta automáticamente al modo claro/oscuro
        }
    }
    
    var accentColor: Color {
        switch self {
        case .ipn:
            return Color(red: 0.76, green: 0.55, blue: 0.0) // Dorado IPN (#C28C00)
        case .escom:
            return Color(red: 0.0, green: 0.5, blue: 0.82) // Azul claro ESCOM (#0080D2)
        }
    }
    
    var logo: String {
        switch self {
        case .ipn:
            return "ipn_logo" // Debes añadir este asset al proyecto
        case .escom:
            return "escom_logo" // Debes añadir este asset al proyecto
        }
    }
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme = .ipn
    @Published var isDarkMode: Bool = false
    
    static let shared = ThemeManager()
    
    private init() {
        // Detectar si el sistema está en modo oscuro
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            isDarkMode = window.traitCollection.userInterfaceStyle == .dark
        }
    }
    
    func toggleDarkMode() {
        isDarkMode.toggle()
        
        // En una aplicación real, aquí cambiaríamos el modo del sistema
        // Pero para propósitos educativos, solo cambiamos la variable
    }
    
    func switchTheme(to theme: AppTheme) {
        currentTheme = theme
    }
}
