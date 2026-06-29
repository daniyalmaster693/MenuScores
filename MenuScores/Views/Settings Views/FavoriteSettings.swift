//
//  FavoriteSettings.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-06-20.
//

import SwiftUI

struct FavoritesSettingsView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    @AppStorage("autoPinFavorites") private var autoPinFavorites = false

    var body: some View {
        VStack(spacing: 4) {
            Text("Favorites")
                .font(.title2)
                .bold()

            Form {
                Section {
                    Toggle(isOn: $autoPinFavorites) {
                        HStack {
                            Image(systemName: "pin")
                                .foregroundColor(.secondary)
                            Text("Auto-pin favorite team games")
                        }
                    }
                }
            }
            .formStyle(.grouped)
        }
    }
}
