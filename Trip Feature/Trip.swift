//
//  Trip.swift
//  Tripper
//
//  Created by Valeria Chub on 13.01.2022.
//

import Foundation

public struct Trip: Hashable {
    public let id: String
    public let country: String
    public let dateFrom: Date
    public let dateTo: Date
    public let imageURL: URL
    
    public init(id: String, country: String, dateFrom: Date, dateTo: Date, imageURL: URL) {
        self.id = id
        self.country = country
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.imageURL = imageURL
    }
}
