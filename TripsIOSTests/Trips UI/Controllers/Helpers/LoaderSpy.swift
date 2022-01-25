//
//  LoaderSpy.swift
//  TripsIOSTests
//
//  Created by Valeria Chub on 21.01.2022.
//

import Foundation
import Tripper

class LoaderSpy: TripLoader, TripImageDataLoader {
    
    // MARK: - TripLoader
    
    var loadCallCount: Int {
        return completions.count
    }
    
    var completions = [(LoadResult) -> Void]()
    
    func load(completion: @escaping (LoadResult) -> Void) {
        completions.append(completion)
    }
    
    func completeLoadSuccessfully(with trips: [Trip], at index: Int = 0) {
        completions[index](.success(trips))
    }
    
    func completeLoad(with error: NSError, at index: Int = 0) {
        completions[index](.failure(error))
    }
    
    func save(_ trip: Trip, completion: @escaping (SaveResult) -> Void) {
        
    }
    
    // MARK: - TripImageDataLoader
    
    var requestedImageURLs: [URL] {
        return imageCompletions.map { $0.url }
    }
    private(set) var cancelledImageURLs = [URL]()
    
    private(set) var imageCompletions = [(url: URL, completion: (TripImageDataLoader.Result) -> Void)]()
    
    private struct TaskSpy: TripImageDataTask {
        var callback: (() -> Void)?
        func cancel() {
            callback?()
        }
    }
    
    func load(from url: URL, completion: @escaping (TripImageDataLoader.Result) -> Void) -> TripImageDataTask {
        imageCompletions.append((url, completion))
        return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
    }
    
    func completeImageLoadSuccessfully(with data: Data, at index: Int = 0) {
        imageCompletions[index].completion(.success(data))
    }
    
    func completeImageLoadWithError(at index: Int = 0) {
        let error = NSError(domain: "any error", code: 0)
        imageCompletions[index].completion(.failure(error))
    }
}
