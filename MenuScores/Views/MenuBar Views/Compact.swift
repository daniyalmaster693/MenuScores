//
//  Compact.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-08-07.
//

import SwiftUI

struct CompactMenuBar: View {
    var body: some View {
        HStack(spacing: 6) {
            HStack {
                AsyncImage(
                    url: URL(string:
                        "https://a.espncdn.com/i/teamlogos/mlb/500/scoreboard/tor.png"
                    )
                ) { image in
                    image
                        .resizable()
                        .interpolation(.high)
                        .scaledToFit()

                } placeholder: {
                    Color.clear
                }
                .frame(width: 18, height: 18)

                Text("0")
                    .font(.system(size: 14))
            }

            Text("-")
                .font(.system(size: 14))

            HStack {
                Text("0")
                    .font(.system(size: 14))

                AsyncImage(
                    url: URL(string:
                        "https://a.espncdn.com/i/teamlogos/mlb/500/scoreboard/phi.png"
                    )
                ) { image in
                    image
                        .resizable()
                        .interpolation(.high)
                        .scaledToFit()
                } placeholder: {
                    Color.clear
                }
                .frame(width: 18, height: 18)
            }
        }
        .padding(.horizontal, 7)
        .frame(width: 105, height: 22)
    }
}
