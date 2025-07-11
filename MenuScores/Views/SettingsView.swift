//
//  SettingsView.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-11.
//

import SwiftUI

struct SettingsView: View {
    enum Tab: String, CaseIterable, Identifiable {
        case general = "General"
        case league = "Leagues"

        var id: String { rawValue }
    }

    @State private var selectedTab: Tab? = .general

    var body: some View {
        NavigationSplitView {
            VStack(alignment: .leading, spacing: 8) {
                List(Tab.allCases, selection: $selectedTab) { tab in
                    Label(tab.rawValue, systemImage: tab.iconName)
                        .tag(tab)
                }
                .listStyle(.sidebar)
            }
            .padding(.top, 7)
            .frame(minWidth: 100)
        } detail: {
            Group {
                switch selectedTab {
                case .general:
                    GeneralSettingsView()
                case .league:
                    LeagueSettingsView()
                default:
                    Text("Select a tab")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            .navigationTitle("")
            .toolbar(.hidden)
        }
        .frame(minWidth: 700, idealWidth: 700, maxWidth: 700)
    }
}

private extension SettingsView.Tab {
    var iconName: String {
        switch self {
        case .general: return "gearshape"
        case .league: return "sportscourt"
        }
    }
}
