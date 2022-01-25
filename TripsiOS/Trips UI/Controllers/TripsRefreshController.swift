//
//  TripsRefreshController.swift
//  TripsIOS
//
//  Created by Valeria Chub on 20.01.2022.
//

import Foundation
import UIKit

public final class TripsRefreshController: NSObject {
    private(set) lazy var refreshControl: UIRefreshControl = {
        return bind(UIRefreshControl())
    }()
    
    private var viewModel: TripsViewModel
    
    init(viewModel: TripsViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.loadTrips()
    }
    
    private func bind(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChanged = { [weak view] isLoading in
            if isLoading {
                view?.beginRefreshing()
            } else {
                view?.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
