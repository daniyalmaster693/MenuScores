//
//  FavoriteSettings.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-06-20.
//

import SwiftUI

struct FavoriteSettingsView: View {
    // Leagues

    @AppStorage("enableNHL") private var enableNHL = true
    @AppStorage("enableHNCAAM") private var enableHNCAAM = false
    @AppStorage("enableHNCAAF") private var enableHNCAAF = false

    @AppStorage("enableNBA") private var enableNBA = true
    @AppStorage("enableWNBA") private var enableWNBA = false
    @AppStorage("enableNCAAM") private var enableNCAAM = false
    @AppStorage("enableNCAAF") private var enableNCAAF = false

    @AppStorage("enableNFL") private var enableNFL = true
    @AppStorage("enableFNCAA") private var enableFNCAA = false

    @AppStorage("enableMLB") private var enableMLB = true
    @AppStorage("enableBNCAA") private var enableBNCAA = false
    @AppStorage("enableSNCAA") private var enableSNCAA = false

    @AppStorage("enableF1") private var enableF1 = true
    @AppStorage("enableNC") private var enableNC = false
    @AppStorage("enableNCS") private var enableNCS = false
    @AppStorage("enableNCT") private var enableNCT = false
    @AppStorage("enableIRL") private var enableIRL = false

    @AppStorage("enablePGA") private var enablePGA = true
    @AppStorage("enableLPGA") private var enableLPGA = false

    @AppStorage("enableMLS") private var enableMLS = true
    @AppStorage("enableNWSL") private var enableNWSL = false
    @AppStorage("enableUEFA") private var enableUEFA = false
    @AppStorage("enableEUEFA") private var enableEUEFA = false
    @AppStorage("enableWUEFA") private var enableWUEFA = false
    @AppStorage("enableMEX") private var enableMEX = false
    @AppStorage("enableFRA") private var enableFRA = false
    @AppStorage("enableNED") private var enableNED = false
    @AppStorage("enablePOR") private var enablePOR = false
    @AppStorage("enableEPL") private var enableEPL = false
    @AppStorage("enableWEPL") private var enableWEPL = false
    @AppStorage("enableESP") private var enableESP = false
    @AppStorage("enableGER") private var enableGER = false
    @AppStorage("enableITA") private var enableITA = false

    @AppStorage("enableATP") private var enableATP = true
    @AppStorage("enableWTA") private var enableWTA = false

//    @AppStorage("enableUFC") private var enableUFC = true

    @AppStorage("enableNLL") private var enableNLL = false
    @AppStorage("enablePLL") private var enablePLL = false
    @AppStorage("enableLNCAAM") private var enableLNCAAM = false
    @AppStorage("enableLNCAAF") private var enableLNCAAF = false

    @AppStorage("enableVNCAAM") private var enableVNCAAM = false
    @AppStorage("enableVNCAAF") private var enableVNCAAF = false

    @AppStorage("enableOMIHC") private var enableOMIHC = false
    @AppStorage("enableOWIHC") private var enableOWIHC = false
    @AppStorage("enableOMB") private var enableOMB = false
    @AppStorage("enableOWB") private var enableOWB = false

    @AppStorage("enableFFWC") private var enableFFWC = false
    @AppStorage("enableFFWWC") private var enableFFWWC = false
    @AppStorage("enableFFWCQUEFA") private var enableFFWCQUEFA = false
    @AppStorage("enableCONCACAF") private var enableCONCACAF = false
    @AppStorage("enableCONMEBOL") private var enableCONMEBOL = false
    @AppStorage("enableCAF") private var enableCAF = false
    @AppStorage("enableAFC") private var enableAFC = false
    @AppStorage("enableOFC") private var enableOFC = false

    // Favorites Settings View

    var body: some View {
        VStack(spacing: 4) {
            Text("Favorites")
                .font(.title2)
                .bold()
        }
    }
}
