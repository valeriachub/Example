//
//  TripsUIComposer.swift
//  TripsIOS
//
//  Created by Valeria Chub on 20.01.2022.
//

import Foundation
import Tripper
import UIKit

public final class TripsUIComposer {
    private init() {}
    
    public static func tripsComposedWith(loader: TripLoader, imageLoader: TripImageDataLoader) -> TripsViewController {
        let tripsViewModel = TripsViewModel(loader: MainQueueDispatchDecorator(decoratee: loader))
        let refreshController = TripsRefreshController(viewModel: tripsViewModel)
        let tripsController = makeTripsController()
        tripsController.refreshController = refreshController
        
        tripsViewModel.onTripsLoad = adaptTripsToCellControllers(forwardingTo: tripsController, imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader))
        return tripsController
    }
    
    private static func adaptTripsToCellControllers(forwardingTo controller: TripsViewController, imageLoader: TripImageDataLoader) -> ([Trip]) -> Void {
        return { [weak controller] models in
            controller?.trips = models.map { model in
                TripCellController(viewModel:
                                    TripCellViewModel(model: model, imageLoader: imageLoader, imageTransform: UIImage.init))
            }
        }
    }
    
    private static func makeTripsController() -> TripsViewController {
        let bundle = Bundle(for: TripsViewController.self)
        let storyboard = UIStoryboard(name: "Trips", bundle: bundle)
        let tripsController = storyboard.instantiateInitialViewController() as! TripsViewController
        return tripsController
    }
}
