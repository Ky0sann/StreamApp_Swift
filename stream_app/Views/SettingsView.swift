//
//  SettingsView.swift
//  stream_app
//
//  Created by Cours on 05/02/2026.
//
 
import SwiftUI
 
struct SettingsView: View {
    @EnvironmentObject var themeVM: ThemeViewModel
    @ObservedObject var authVM: AuthViewModel
 
    @State private var showAlert = false
    @State private var alertMessage = ""
 
    var body: some View {
        NavigationStack {
            List {
                Section("Apparence") {
                    Picker("Thème", selection: $themeVM.currentTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Label(theme.title, systemImage: theme.icon)
                                .tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }
 
                Section("Cache") {
                    Button("Nettoyer le cache") {
                        clearCache()
                    }
                    .foregroundColor(.red)
                }
 
                Section("équipe de développement") {
                    Link(destination: URL(string: "https://github.com/Ky0sann/StreamApp_Swift")!) {
                        Label("Voir sur GitHub", systemImage: "link")
                    }
                }
 
                Section {
                    HStack(spacing: 12) {
                        NavigationLink(destination: LoginView(authVM: authVM)) {
                            Text("Se connecter")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color.blue)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                        }
 
                        NavigationLink(destination: RegisterView(authVM: authVM)) {
                            Text("S'inscrire")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.blue)
                                )
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Paramètres")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Cache nettoyé"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
 
    private func clearCache() {
        // Taille du cache avant nettoyage
        let cacheSize = getCacheSize()
        
        // Nettoyage
        URLCache.shared.removeAllCachedResponses()
        
        // Message à afficher
        alertMessage = "Cache clear : \(formatBytes(cacheSize))"
        showAlert = true
    }
    
    // Calcul taille cache URLCache
    private func getCacheSize() -> Int {
        let cache = URLCache.shared
        return cache.currentDiskUsage + cache.currentMemoryUsage
    }
    
    // Format en MO
    private func formatBytes(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB] // en MO
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}