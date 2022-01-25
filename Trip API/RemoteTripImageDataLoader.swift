//
//  RemoteTripImageDataLoader.swift
//  TripperTests
//
//  Created by Valeria Chub on 21.01.2022.
//

import Foundation

public class RemoteTripImageDataLoader: TripImageDataLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private class HTTPClientDataTaskWrapper: TripImageDataTask {
        private var completion: ((TripImageDataLoader.Result) -> Void)?
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping(TripImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: TripImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            completion = nil
            wrapped?.cancel()
        }
    }
    
    public func load(from url: URL, completion: @escaping (TripImageDataLoader.Result) -> Void) -> TripImageDataTask {
        let task = HTTPClientDataTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            
            guard self != nil else { return }
            
            task.complete(with: result
                            .mapError { _ in Error.connectivity}
                            .flatMap { (data, response) in
                let validResponse = response.statusCode == 200 && !data.isEmpty
                return validResponse ? .success(data) : .failure(RemoteTripImageDataLoader.Error.invalidData)
            })
        }
        return task
    }
}
