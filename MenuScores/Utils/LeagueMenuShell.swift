//
//  LeagueMenuShell.swift
//  MenuScores
//

import SwiftUI

/// Root `Menu` with a stable identity; live score updates stay in `content` only.
struct LeagueMenuShell<Content: View>: View {
    let title: String
    let league: String
    let onAppearAction: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        Menu(title) {
            content()
        }
        .id("menu-league-\(league)")
        .onAppear(perform: onAppearAction)
    }
}

extension View {
    func stableMenuBarItem(_ id: String) -> some View {
        self.id(id)
    }
}
