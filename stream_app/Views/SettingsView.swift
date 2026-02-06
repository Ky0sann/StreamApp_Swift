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
                        alertMessage = ClearCacheService.clearCache()
                        showAlert = true
                    }
                    .foregroundColor(.red)
                }
                .alert("Cache", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(alertMessage)
                }
                
                Section("Développeurs") {
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
}
