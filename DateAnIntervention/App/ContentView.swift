//
//  ContentView.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var interventions: [Intervention]

    var body: some View {
        TabView {
            // Swipe Tab
            SwipeView()
                .tabItem {
                    Label("Discover", systemImage: "heart.circle.fill")
                }

            // Matches Tab
            MatchesView()
                .tabItem {
                    Label("Matches", systemImage: "flame.fill")
                }

            // Profile/Settings Tab
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(Color.pink)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Intervention.self, inMemory: true)
}
