//
//  MainQueueDispatchDecorator.swift
//  TripsIOS
//
//  Created by Valeria Chub on 22.01.2022.
//

import Foundation
import Tripper

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping() -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
}

extension MainQueueDispatchDecorator: TripLoader where T == TripLoader {
    
    func load(completion: @escaping (LoadResult) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
    
    func save(_ trip: Trip, completion: @escaping (SaveResult) -> Void) {
        decoratee.save(trip, completion: completion)
    }
}

extension MainQueueDispatchDecorator: TripImageDataLoader where T == TripImageDataLoader {
    func load(from url: URL, completion: @escaping (TripImageDataLoader.Result) -> Void) -> TripImageDataTask {
        decoratee.load(from: url) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
