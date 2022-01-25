//
//  TripCell+Extensions.swift
//  TripsIOSTests
//
//  Created by Valeria Chub on 21.01.2022.
//

import Foundation
import TripsIOS

extension TripCell {

    var renderedImage: Data? {
        return tripImageView.image?.pngData()
    }

    var countryText: String? {
        return countryLabel.text
    }
}
