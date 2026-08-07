//
//  Detailed.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-08-07.
//

import SwiftUI

struct DetailedMenuBar: View {
    @State private var headlineText: String = "Kirk leads Blue Jays against the Phillies following 4-hit performance"

    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 4) {
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
                    .frame(width: 32, height: 32)

                    VStack {
                        Text("0")
                            .font(.system(size: 22, weight: .medium))

                        Text("TOR")
                            .font(.system(size: 12, weight: .medium))
                    }
                }

                Text("6:40PM")
                    .font(.system(size: 19, weight: .semibold))
                    .padding(.horizontal, 35)

                HStack(spacing: 4) {
                    VStack {
                        Text("0")
                            .font(.system(size: 22, weight: .medium))

                        Text("PHI")
                            .font(.system(size: 12, weight: .medium))
                    }

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
                    .frame(width: 32, height: 32)
                }
            }

            HStack(spacing: 10) {
                Capsule()
                    .fill(.white)
                    .frame(width: 3, height: 16)

                Text(headlineText)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.top, 10)
            .frame(width: 300, height: 22, alignment: .center)

            HStack(spacing: 6) {
                Image(systemName: "location.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)

                Text("Philadelphia, Pennsylvania 84°")
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.top, 3)
        }
    }
}
