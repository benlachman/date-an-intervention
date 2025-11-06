//
//  SettingsView.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }

                    Link(destination: URL(string: "https://github.com/yourusername/date-an-intervention")!) {
                        HStack {
                            Text("GitHub Repository")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("App") {
                    NavigationLink("API Configuration") {
                        Text("API Configuration coming soon")
                    }

                    NavigationLink("About Climate Interventions") {
                        Text("Educational content coming soon")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
