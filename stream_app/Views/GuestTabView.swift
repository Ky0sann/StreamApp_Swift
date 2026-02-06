//
//  GuestTabView.swift
//  stream_app
//
//  Created by Cours on 05/02/2026.
//
 
import SwiftUI
 
struct GuestTabView: View {
    @ObservedObject var authVM: AuthViewModel
    
 
    var body: some View {
        TabView {
            GuestMovieListView(authVM: authVM)
                .tabItem {
                    Label("Films", systemImage: "film")
                }
 
            GuestPeopleListView()
                .tabItem {
                    Label("Cast", systemImage: "person.3")
                }
            
            SettingsView(authVM: authVM)
                .tabItem {
                    Label("Paramètres", systemImage: "gear")
                }
            
        }
    }
}
