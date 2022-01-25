//
//  TripsViewModel.swift
//  TripsIOS
//
//  Created by Valeria Chub on 20.01.2022.
//

import Foundation
import Tripper

final class TripsViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let loader: TripLoader
        
    init(loader: TripLoader) {
        self.loader = loader
    }
    
    var onLoadingStateChanged: Observer<Bool>?
    var onTripsLoad: Observer<[Trip]>?
    
    func loadTrips() {
        onLoadingStateChanged?(true)
        loader.load { [weak self] result in
            if let trips = try? result.get() {
                self?.onTripsLoad?(trips)
            }
            self?.onLoadingStateChanged?(false)
        }
    }
}
