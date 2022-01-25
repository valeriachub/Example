//
//  RemoteTripMapper.swift
//  Tripper
//
//  Created by Valeria Chub on 13.01.2022.
//

import Foundation

final class RemoteTripMapper {
    
    private struct Root: Codable {
        let items: [Item]
        
        var trips: [Trip] {
            return items.map { $0.item }
        }
    }
    
    private struct Item: Codable {
        let id: String
        let country: String
        let date_from: String
        let date_to: String
        let image: String
        
        var item: Trip {
            return Trip(id: id,
                        country: country,
                        dateFrom: date_from.toLocalDate(),
                        dateTo: date_to.toLocalDate(),
                        imageURL: URL(string: image)!)
        }
    }
    
    static func map(_ data: Data) throws -> [Trip] {
        guard let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteTripLoader.Error.invalidData
        }
        
        return root.trips
    }
    
    static func map(_ trip: Trip) throws -> Data {
        let item = Item(id: trip.id,
                        country: trip.country,
                        date_from: trip.dateFrom.toRemoteDate(),
                        date_to: trip.dateTo.toRemoteDate(),
                        image: trip.imageURL.absoluteString)
        let root = Root(items: [item])
        
        guard let data = try? JSONEncoder().encode(root) else {
            throw RemoteTripLoader.Error.invalidData
        }
        
        return data
    }
}

private extension String {
    func toLocalDate() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: self)!
    }
}

public extension Date {
    func toRemoteDate() -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
}
