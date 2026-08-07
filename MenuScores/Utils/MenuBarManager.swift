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

        button.action = #selector(toggleMenu(_:))
        button.target = self

        statusItem = item
    }

    @objc private func toggleMenu(_ sender: Any?) {
        let menu = NSMenu()

        let item = NSMenuItem()

        let hosting = NSHostingView(
            rootView: DetailedMenuBar()
        )

        hosting.frame = NSRect(
            x: 0,
            y: 0,
            width: 330,
            height: 150
        )

        item.view = hosting

        menu.addItem(item)

        statusItem.menu = menu
        statusItem.button?.performClick(nil)
    }
}
