//
//  CountryFlag.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-10-12.
//

import Foundation

func f1CountryCode(for raceName: String) -> String {
    let mapping: [String: String] = [
        "Australia": "aus",
        "Bahrain": "bhr",
        "Spain": "esp",
        "Monaco": "mco",
        "Azerbaijan": "aze",
        "Canada": "can",
        "Austria": "aut",
        "United Kingdom": "gbr",
        "Britain": "gbr",
        "Hungary": "hun",
        "Belgium": "bel",
        "Netherlands": "nld",
        "Italy": "ita",
        "Russia": "rus",
        "Singapore": "sgp",
        "Japan": "jpn",
        "USA": "usa",
        "Mexico": "mex",
        "Brazil": "bra",
        "Qatar": "qat",
        "Saudi Arabia": "ksa",
        "United Arab Emirates": "are",
        "France": "fra",
        "Germany": "deu",
        "Turkey": "tur",
        "South Africa": "zaf",
        "Malaysia": "mys",
        "China": "chn"
    ]

    for (country, code) in mapping {
        if raceName.localizedCaseInsensitiveContains(country) {
            return code
        }
    }
    return "usa"
}
