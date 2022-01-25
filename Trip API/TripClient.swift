//
//  HTTPClient.swift
//  Tripper
//
//  Created by Valeria Chub on 13.01.2022.
//

import Foundation

public protocol TripClient {
    
    typealias FetchResult = Swift.Result<Data, Error>
    func fetch(completion: @escaping(FetchResult) -> Void)
    
    typealias InsertionResult = Swift.Result<Void, Error>
    func insert(_ data: Data, completion: @escaping(InsertionResult) -> Void)
}
