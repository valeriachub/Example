//
//  TripImageDataLoader.swift
//  Tripper
//
//  Created by Valeria Chub on 20.01.2022.
//

import Foundation

public protocol TripImageDataTask {
    func cancel()
}

public protocol TripImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func load(from url: URL, completion: @escaping (Result) -> Void) -> TripImageDataTask
}
