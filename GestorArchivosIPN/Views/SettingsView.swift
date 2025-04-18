//
//  SettingsView.swift
//  GestorArchivosIPN
//
//  Created by Giovanni Javier Longoria Bunoust on 17/04/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAboutSheet = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Apariencia")) {
                    // Selector de tema
                    Picker("Tema", selection: $themeManager.currentTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    // Toggle para modo oscuro
                    Toggle("Modo oscuro", isOn: $themeManager.isDarkMode)
                        .onChange(of: themeManager.isDarkMode) { _ in
                            themeManager.toggleDarkMode()
                        }
                }
                
                Section(header: Text("Información")) {
                    // Botón para mostrar información sobre la aplicación
                    Button("Acerca de la aplicación") {
                        showingAboutSheet = true
                    }
                    
                    // Versión de la aplicación
                    HStack {
                        Text("Versión")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
                
                // Botón para restablecer la configuración por defecto
                Section {
                    Button("Restablecer configuración") {
                        themeManager.currentTheme = .ipn
                        themeManager.isDarkMode = false
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Ajustes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .accentColor(themeManager.currentTheme.primaryColor)
            .sheet(isPresented: $showingAboutSheet) {
                AboutView()
            }
        }
    }
}

struct AboutView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Image(themeManager.currentTheme.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding()
                    // Alternativa si no tienes las imágenes, muestra un icono de sistema:
                    // Image(systemName: "folder.fill")
                    // .resizable()
                    // .scaledToFit()
                    // .frame(width: 100, height: 100)
                    // .foregroundColor(themeManager.currentTheme.primaryColor)
                    // .padding()
                
                Text("Gestor de Archivos IPN")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 1)
                
                Text("Versión 1.0.0")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                Text("Desarrollado como proyecto educativo")
                    .font(.body)
                
                Text("Instituto Politécnico Nacional")
                    .font(.headline)
                    .padding(.top, 5)
                
                Text("ESCOM")
                    .font(.headline)
                    .padding(.top, 1)
                    .foregroundColor(themeManager.currentTheme.primaryColor)
                
                Spacer()
                
                Text("© 2025 - Todos los derechos reservados")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }
            .padding()
            .navigationTitle("Acerca de")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
