//
//  SettingsView.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-11.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedItem: String? = "general"

    var body: some View {
        NavigationSplitView {
            VStack {
                List(selection: $selectedItem) {
                    HStack {
                        Image(systemName: "gearshape")
                            .frame(width: 18, height: 18)
                        Text("General")
                    }
                    .tag("general")

                    HStack {
                        Image(systemName: "slider.horizontal.3")
                            .frame(width: 18, height: 18)
                        Text("Behavior")
                    }
                    .tag("behavior")

                    HStack {
                        Image(systemName: "bell.badge")
                            .frame(width: 18, height: 18)
                        Text("Alerts")
                    }
                    .tag("alerts")

                    HStack {
                        Image(systemName: "star")
                            .frame(width: 18, height: 18)
                        Text("Favorites")
                    }
                    .tag("favorites")

                    HStack {
                        Image(systemName: "sportscourt")
                            .frame(width: 18, height: 18)
                        Text("Leagues")
                    }
                    .tag("leagues")

                    HStack {
                        Image(systemName: "info.circle")
                            .frame(width: 18, height: 18)
                        Text("About")
                    }
                    .tag("about")
                }
                .listStyle(.sidebar)
                .padding(.top, 7)
            }
            .frame(minWidth: 175)
        } detail: {
            Group {
                switch selectedItem {
                case "general":
                    GeneralSettingsView()
                        .navigationTitle("General")
                case "behavior":
                    BehaviorSettingsView()
                        .navigationTitle("Behavior")
                case "alerts":
                    AlertSettingsView()
                        .navigationTitle("Alerts")
                case "favorites":
                    FavoritesSettingsView()
                        .navigationTitle("Favorites")
                case "leagues":
                    LeagueSettingsView()
                        .navigationTitle("Leagues")
                case "about":
                    AboutSettingsView()
                        .navigationTitle("About")
                default:
                    Text("No item selected")
                }
            }
        }
        .frame(minWidth: 750, minHeight: 500)
    }
}
