//
//  AppLinksView.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-02.
//

import SwiftUI

struct AppLinksView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        VStack(spacing: 8) {
            if let iconPath = Bundle.main.path(forResource: "AppIcon", ofType: "icns"),
               let nsImage = NSImage(contentsOfFile: iconPath)
            {
                Image(nsImage: nsImage)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
            } else {
                Image(systemName: "app.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
            }

            Text("MenuScores ")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
                +
                Text(version)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            Form {
                Section {
                    HStack {
                        Text("Version")
                            .foregroundColor(.primary)
                        Spacer()
                        Text(version)
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    ForEach(
                        [
                            ("MenuScores Help", "https://github.com/daniyalmaster693/MenuScores"),
                            ("Feedback", "https://github.com/daniyalmaster693/MenuScores/issues/new"),
                            ("Changelog", "https://github.com/daniyalmaster693/MenuScores/releases"),
                            ("License", "https://github.com/daniyalmaster693/MenuScores/blob/main/License"),

                        ],
                        id: \.0
                    ) { item in
                        Button(action: {
                            if let url = URL(string: item.1) {
                                NSWorkspace.shared.open(url)
                            }
                        }) {
                            HStack {
                                Text(item.0)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .formStyle(.grouped)
            .frame(maxWidth: 725)
            .padding(.top, 7)

            Divider()

            Button("Done") {
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .padding(.top, 7)
        .frame(width: 350, height: 425)
    }
}
