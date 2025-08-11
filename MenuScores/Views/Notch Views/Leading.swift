//
//  Leading.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-09.
//

import SwiftUI

struct CompactLeading: View {
    @ObservedObject var notchViewModel: NotchViewModel
    var sport: String

    var body: some View {
        if let game = notchViewModel.game {
            if sport != "Racing" && sport != "Golf" {
                HStack {
                    AsyncImage(
                        url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")
                    ) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.black
                    }
                    .frame(width: 18, height: 18)

                    Text("\(game.competitions[0].competitors?[1].score ?? "-")")
                        .font(.system(size: 14, weight: .semibold))
                }
            }

            if sport == "Racing" {
                HStack {
                    AsyncImage(
                        url: URL(
                            string:
                            "https://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/f1.png&w=100&h=100&transparent=true"
                        )
                    ) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 18, height: 18)
                }
            }

            if sport == "Golf" {
                HStack {
                    AsyncImage(
                        url: URL(
                            string:
                            "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-golf.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                        )
                    ) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 18, height: 18)
                }
            }
        }
    }
}
