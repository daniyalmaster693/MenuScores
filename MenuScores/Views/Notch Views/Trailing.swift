//
//  Trailing.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-09.
//

import SwiftUI

struct CompactTrailing: View {
    @ObservedObject var notchViewModel: NotchViewModel

    var body: some View {
        if let game = notchViewModel.game {
            HStack {
                Text("\(game.competitions[0].competitors?[0].score ?? "-")")
                    .font(.system(size: 14, weight: .semibold))

                AsyncImage(
                    url: URL(string: game.competitions[0].competitors?[0].team?.logo ?? "")
                ) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.black
                }
                .frame(width: 18, height: 18)
            }

//            HStack {
//                if let lap = game.competitions[4].status.period {
//                    Text("L\(lap)")
//                        .font(.system(size: 14, weight: .semibold))
//                } else {
//                    Text("L -")
//                        .font(.system(size: 14, weight: .semibold))
//                }
//            }

//            HStack {
//                if let lap = game.competitions[0].status.period {
//                    Text("R\(lap)")
//                        .font(.system(size: 14, weight: .semibold))
//                } else {
//                    Text("R -")
//                        .font(.system(size: 14, weight: .semibold))
//                }
//            }
        }
    }
}
