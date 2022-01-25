//
//  TripLoader.swift
//  Tripper
//
//  Created by Valeria Chub on 13.01.2022.
//

import Foundation

public protocol TripLoader {
    
    typealias LoadResult = Swift.Result<[Trip], Error>
    func load(completion: @escaping(LoadResult) -> Void)
    
    typealias SaveResult = Swift.Result<Void, Error>
    func save(_ trip: Trip, completion: @escaping(SaveResult) -> Void)
}
