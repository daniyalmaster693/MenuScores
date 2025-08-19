//
//  SettingsView.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-11.
//

import Sparkle
import SwiftUI

struct SettingsView: View {
    @State private var showingAboutModal = false

    @State private var isHovered = false
    let updater: SPUUpdater

    enum Tab: String, CaseIterable, Identifiable {
        case general = "General"
        case behavior = "Behavior"
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

                Spacer()

                Button {
                    showingAboutModal = true
                } label: {
                    HStack(spacing: 8) {
                        if let iconPath = Bundle.main.path(forResource: "AppIcon", ofType: "icns"),
                           let nsImage = NSImage(contentsOfFile: iconPath)
                        {
                            Image(nsImage: nsImage)
                                .resizable()
                                .frame(width: 32, height: 32)
                                .cornerRadius(6)
                        } else {
                            Image(systemName: "app.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .cornerRadius(6)
                        }

                        VStack(alignment: .leading) {
                            Text("MenuScores")
                                .font(.footnote)
                                .bold()

                            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                                Text("Version (\(version))")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: 150, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isHovered ? Color.gray.opacity(0.15) : Color.clear)
                    )
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    isHovered = hovering
                }
            }
            .frame(minWidth: 150)
        } detail: {
            Group {
                switch selectedTab {
                case .general:
                    GeneralSettingsView(updater: updater)
                case .behavior:
                    BehaviorSettingsView()
                case .league:
                    LeagueSettingsView()
                default:
                    Text("Select a tab")
                }
            }
            .frame(
                maxWidth: .infinity, maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding()
            .navigationTitle("")
            .toolbar(.hidden)
        }
        .frame(minWidth: 700, idealWidth: 700, maxWidth: 700)
        .sheet(isPresented: $showingAboutModal) {
            AppLinksView()
        }
    }
}

private extension SettingsView.Tab {
    var iconName: String {
        switch self {
        case .general: return "gearshape"
        case .behavior: return "slider.horizontal.3"
        case .league: return "sportscourt"
        }
    }
}
