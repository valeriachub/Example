//
//  RemoteTripLoader.swift
//  Tripper
//
//  Created by Valeria Chub on 13.01.2022.
//

import Foundation

public class RemoteTripLoader: TripLoader {
    
    private let client: TripClient
    
    public init(client: TripClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
}

extension RemoteTripLoader {
    public func load(completion: @escaping (TripLoader.LoadResult) -> Void) {
        client.fetch { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case let .success(data):
                completion(self.map(data))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private func map(_ data: Data) -> TripLoader.LoadResult {
        do {
            return .success(try RemoteTripMapper.map(data))
        } catch {
            return .failure(Error.invalidData)
        }
    }
}

extension RemoteTripLoader {
    
    public func save(_ trip: Trip, completion: @escaping (SaveResult) -> Void) {
        
        let data = try! RemoteTripMapper.map(trip)
        
        client.insert(data) { [weak self] result in
            
            guard self != nil else { return }
            
            switch result {
            case .success:
                completion(.success(()))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
        
    }
}
