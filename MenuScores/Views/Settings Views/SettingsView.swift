//
//  SettingsView.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-11.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedTab = "General"

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                NavigationLink(value: "General") {
                    Label("General", systemImage: "gear")
                }

                NavigationLink(value: "Behavior") {
                    Label("Behavior", systemImage: "slider.horizontal.3")
                }

                NavigationLink(value: "Alerts") {
                    Label("Alerts", systemImage: "bell")
                }

                NavigationLink(value: "Favorites") {
                    Label("Favorites", systemImage: "star")
                }

                NavigationLink(value: "Leagues") {
                    Label("Leagues", systemImage: "sportscourt")
                }

                NavigationLink(value: "About") {
                    Label("About", systemImage: "info.circle")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationSplitViewColumnWidth(175)

        } detail: {
            Group {
                switch selectedTab {
                case "General":
                    GeneralSettingsView()
                        .navigationTitle("General")
                case "Behavior":
                    BehaviorSettingsView()
                        .navigationTitle("Behavior")
                case "Alerts":
                    AlertSettingsView()
                        .navigationTitle("Alerts")
                case "Favorites":
                    FavoritesSettingsView()
                        .navigationTitle("Favorites")
                case "Leagues":
                    LeagueSettingsView()
                        .navigationTitle("Leagues")
                case "About":
                    AboutSettingsView()
                        .navigationTitle("About")
                default:
                    GeneralSettingsView()
                        .navigationTitle("General")
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .formStyle(.grouped)
        .background(Color(NSColor.windowBackgroundColor))
        .frame(minWidth: 750, minHeight: 500)
    }
}
