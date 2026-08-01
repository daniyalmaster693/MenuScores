//
//  AboutSettings.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-08-01.
//

import AppKit
import SwiftUI

struct AboutSettingsView: View {
    var body: some View {
        VStack(spacing: 4) {
            Form {
                Section("Version Info") {
                    HStack {
                        Text("Version")
                        Spacer()

                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Build Number")
                        Spacer()

                        Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Links") {
                    let links = [
                        ("MenuScores Help", "https://github.com/daniyalmaster693/MenuScores#usage"),
                        ("Feedback", "https://github.com/daniyalmaster693/MenuScores/issues/new"),
                        ("Changelog", "https://github.com/daniyalmaster693/MenuScores/releases"),
                        ("Website", "https://menuscores.vercel.app"),
                        ("License", "https://github.com/daniyalmaster693/MenuScores/blob/main/License")
                    ]

                    ForEach(links, id: \.0) { link in
                        Button {
                            if let url = URL(string: link.1) {
                                NSWorkspace.shared.open(url)
                            }
                        } label: {
                            HStack {
                                Text(link.0)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .formStyle(.grouped)
        }
    }
}
