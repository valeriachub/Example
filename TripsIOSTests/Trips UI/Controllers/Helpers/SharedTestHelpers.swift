//
//  SharedHelperMethods.swift
//  TripsIOSTests
//
//  Created by Valeria Chub on 21.01.2022.
//

import Foundation
import Tripper

func anyNSError() -> NSError {
    return NSError(domain: "Any Error", code: 0)
}

func makeTrip(country: String = "Any Country", days: Int = 0, cities: Int = 0, places: Int = 0, pictures: Int = 0) -> Trip {
    return Trip(id: UUID().uuidString, country: country, dateFrom: Date(timeIntervalSince1970: 1641204000), dateTo: Date(timeIntervalSince1970: 1641463200), imageURL: URL(string: "https://any-url")!)
}
