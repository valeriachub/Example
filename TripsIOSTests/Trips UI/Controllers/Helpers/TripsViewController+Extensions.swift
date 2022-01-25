//
//  TripsViewController+Extensions.swift
//  TripsIOSTests
//
//  Created by Valeria Chub on 21.01.2022.
//

import Foundation
import TripsIOS
import UIKit

extension TripsViewController {

    private var tripsSection: Int {
        return 0
    }

    func numberOfRenderedTripViews() -> Int {
        return collectionView.numberOfItems(inSection: tripsSection)
    }

    func tripView(at row: Int) -> UICollectionViewCell? {
        let ds = collectionView.dataSource
        let indexPath = IndexPath(row: row, section: tripsSection)
        return ds?.collectionView(collectionView, cellForItemAt: indexPath)
    }

    func simulateTripNearVisible(at index: Int) {
        let ds = collectionView.prefetchDataSource
        let indexPath = IndexPath(row: index, section: tripsSection)
        ds?.collectionView(collectionView, prefetchItemsAt: [indexPath])
    }

    func simulateTripNotNearVisible(at index: Int) {
        simulateTripNearVisible(at: index)

        let ds = collectionView.prefetchDataSource
        let indexPath = IndexPath(row: index, section: tripsSection)
        ds?.collectionView?(collectionView, cancelPrefetchingForItemsAt: [indexPath])
    }

    @discardableResult
    func simulateTripVisible(at index: Int) -> TripCell? {
        return tripView(at: index) as? TripCell
    }

    @discardableResult
    func simulateTripNotVisible(at row: Int) -> TripCell? {
        let view = simulateTripVisible(at: row)

        let delegate = collectionView.delegate
        let indexPath = IndexPath(row: row, section: tripsSection)
        delegate?.collectionView?(collectionView, didEndDisplaying: view!, forItemAt: indexPath)

        return view
    }

    func simulateUserInitiateTripsReload() {

        scrollView.refreshControl?.allTargets.forEach { target in
            scrollView.refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }

    var isShowLoadingIndicator: Bool {
        return scrollView.refreshControl?.isRefreshing == true
    }
}
