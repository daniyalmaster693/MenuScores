//
//  Updater.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-07-07.
//

import AppKit
import Foundation

class UpdateManager: ObservableObject {
    @Published var updateAvailable: Bool = false

    func checkForUpdates() {
        let alert = NSAlert()

        if updateAvailable == true {
            alert.messageText = "Update Available"
            alert.informativeText = "A new version of MenuScores is available. Click the download button to open the newest release."
            alert.addButton(withTitle: "Download")
            alert.addButton(withTitle: "Cancel")
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                if let url = URL(string: "https://github.com/daniyalmaster693/MenuScores/releases/tag/2.1.3") {
                    NSWorkspace.shared.open(url)
                }
            }
        } else {
            alert.messageText = "Up to Date!"
            alert.informativeText = "Your on the latest version of MenuScores."
            alert.addButton(withTitle: "Done")
            alert.runModal()
        }
    }
}
