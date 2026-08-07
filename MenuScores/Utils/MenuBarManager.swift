//
//  MenuBarManager.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-08-07.
//

import AppKit
import SwiftUI

@MainActor
class MenuBarManager {
    static let shared = MenuBarManager()

    private var statusItem: NSStatusItem!
    private var detailedPanel: NSPanel?

    private init() {}

    func show() {
        guard statusItem == nil else { return }

        let item = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.variableLength
        )

        guard let button = item.button else {
            return
        }

        let hostingView = NSHostingView(
            rootView: CompactMenuBar()
        )

        hostingView.translatesAutoresizingMaskIntoConstraints = false

        button.addSubview(hostingView)

        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: button.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])

        button.isBordered = false

        statusItem = item
    }
}
